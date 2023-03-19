ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('lsc_tablet:checkfp', function(source, cb)
    local steamid  = false

  for k,v in pairs(GetPlayerIdentifiers(source))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = tostring(v)
      end
    
  end

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier=@steamid", {['@steamid'] = steamid}, function(grades)
        for k, result in pairs(grades) do
                cb(result)
        end
    end)

end)

RegisterServerEvent('lsc_tablet:wyslijfaktura')
AddEventHandler('lsc_tablet:wyslijfaktura', function(data,target)
  TriggerClientEvent('wyswietlfaktura', target, data)
end)


RegisterServerEvent('lsc_tablet:zaplacfakture')
AddEventHandler('lsc_tablet:zaplacfakture', function(data)
  local _source = source
  local target = ESX.GetPlayerFromId(_source)
  local steamid  = false

  for k,v in pairs(GetPlayerIdentifiers(_source))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = tostring(v)
      end
    
  end

  print(data.pracownik .." ".. data.powod)
  target.removeAccountMoney('bank', tonumber(data.kwota))


  local dane = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier=@hex', {
		['@hex'] = steamid,
	})


  local daneobywatela = dane[1].firstname .. ' ' .. dane[1].lastname
  TriggerClientEvent('obywatelzaplacił',-1, data,daneobywatela)




    MySQL.Async.fetchAll("INSERT INTO faktury (pracownik, dostajacy, kwota, powod,pracownik_steamid) VALUES (@pracownik, @dostajacy,@kwota,@powod,@steamid);", {
      ['@kwota'] = data.kwota,
      ['@powod'] = data.powod,
      ['@pracownik'] = data.pracownik,
      ['@dostajacy'] = daneobywatela,
      ['@steamid'] = data.steamid,
  
    }, function() end)






end)



RegisterServerEvent('lsc_tablet:wyszukajfakture')
AddEventHandler('lsc_tablet:wyszukajfakture', function(data)
  local _source = source
  -- whereClausure = 'LOWER(T.fullName) like LOWER(\'%' .. dane .. '%\')'


  -- local data = MySQL.Sync.fetchAll('SELECT * from (select *, CONCAT(FIRSTNAME, \' \', LASTNAME) AS fullName FROM users) as T WHERE ' .. whereClausure, {})

  local sql = nil
  if data.opcja == 1 then
    -- pracownik
    local str = data.dane
    str = str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  
  
    sql = MySQL.Sync.fetchAll('SELECT * FROM faktury WHERE pracownik LIKE ' .. '"%' .. str .. '%"', {})

    if sql[1] then
      TriggerClientEvent('faktury', _source, sql)
    else
      TriggerClientEvent('faktury', _source, false)
    end
  end
  if data.opcja == 2 then
        -- klient
        local str = data.dane
        str = str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
      
      
        sql = MySQL.Sync.fetchAll('SELECT * FROM faktury WHERE dostajacy LIKE ' .. '"%' .. str .. '%"', {})
        if sql[1] then
          TriggerClientEvent('faktury', _source, sql)
        else
          TriggerClientEvent('faktury', _source, false)
        end
  end
  if data.opcja == 3 then
        -- id
      
      
        sql = MySQL.Sync.fetchAll('SELECT * FROM faktury WHERE id=@id', {
          ['@id']=data.dane
        })

        if sql[1] then
          TriggerClientEvent('faktury', _source, sql)
        else
          TriggerClientEvent('faktury', _source, false)
        end

  end


end)

ESX.RegisterServerCallback('lsc_tablet:statystyki', function(source, cb)
  local steamid  = false

for k,v in pairs(GetPlayerIdentifiers(source))do
      
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steamid = tostring(v)
    end
  
end
  local callback = {}
  local gracz_kwota = 0
  local gracz_iloscfaktur = 0
  local firma_kwota = 0
  local firma_iloscfaktur = 0
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  MySQL.Async.fetchAll("SELECT * FROM faktury WHERE pracownik_steamid=@steamid", {['@steamid'] = steamid}, function(grades)
      for k, result in pairs(grades) do
        gracz_kwota=gracz_kwota+result.kwota
        gracz_iloscfaktur = gracz_iloscfaktur+1
      end
      callback['gracz_kwota'] = gracz_kwota
      callback['gracz_iloscfaktur'] = gracz_iloscfaktur

  MySQL.Async.fetchAll("SELECT * FROM faktury", {}, function(grades)
      for k, result in pairs(grades) do
        firma_kwota=firma_kwota+result.kwota
        firma_iloscfaktur = firma_iloscfaktur+1
      end
      callback['firma_kwota'] = firma_kwota
      callback['firma_iloscfaktur'] = firma_iloscfaktur

      cb(callback)
    end)

      

  end)

end)



ESX.RegisterServerCallback('lsc_tablet:checkhex', function(source, cb)
  local steamid  = false

for k,v in pairs(GetPlayerIdentifiers(source))do
      
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steamid = tostring(v)
    end
  
end
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier=@steamid", {['@steamid'] = steamid}, function(grades)

    cb(grades)
end)




end)