 local ind = {l = false, r = false}
pokazujhud=false
ESX = nil
local tabletEntity = nil
local tabletModel = "glibcat_mdt_prop"
local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"
Citizen.CreateThread(function()
	pokazujhud=false
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
		
		pokazujhud=false
		Citizen.Wait(500)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("tablet_lsc", function(source, args, rawCommand)
	if ESX.PlayerData.job.name == 'mecano' then
		if pokazujhud==false then
			pokazujhud=true
			startTabletAnimation()

	ESX.TriggerServerCallback('lsc_tablet:checkfp', function(ils)
		local fpname = ils.firstname .. ' ' .. ils.lastname
		SetNuiFocus(true, true)
		SendNUIMessage({
			showhud = true,
			player = fpname,
			pokazobywateli = false,
		})
	end)
		else
			stopTabletAnimation()
			SetNuiFocus(false, false)
			pokazujhud=false
			SendNUIMessage({
				showhud = false
			})
		end
	else
	end
end, false)

-- RegisterCommand("test", function(source, args, rawCommand)
	
-- 	SetNuiFocus(true, true	)
-- 	data ={
-- 		powod= "Lorem ipsum dolor sit amet, <br/>consectetur adipiscing elit. Morbi aliquam nunc vel est ultricies,<br/> ut interdum quam aliquet. Proin faucibus tristique maximus. Ut laoreet rutrum sem, <br/>sed ultrices lectus lacinia nec. Donec eget feugiat lectus. Praesent lobortis scelerisque lacus. Quisque tristique nisi a libero facilisis pulvinar. Fusce posuere mi vel.",
-- 		kwota= 123,
-- 		pracownik="Janek Wiertarka",
-- 	}
-- 	SendNUIMessage({
-- 		faktura = true,
-- 		data = data
-- 	})
-- end, false)


RegisterNUICallback('wylacztablet', function()
	SetNuiFocus(false, false)
	ExecuteCommand('tablet_lsc')
end)

RegisterNUICallback('anulujfakture', function()
	SetNuiFocus(false, false)
end)

RegisterNUICallback('wyslijfaktura', function(data)
	ESX.TriggerServerCallback('lsc_tablet:checkhex', function(steamid)

		
		data.steamid = steamid[1].identifier
		data.pracownik = steamid[1].firstname .. ' ' .. steamid[1].lastname

		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			TriggerServerEvent('lsc_tablet:wyslijfaktura', data,GetPlayerServerId(closestPlayer))
		else
			ESX.ShowNotification('Nie ma komu wystawic faktury.Podejdź bliżej klienta.')	
		end

	end)
	



	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('lsc_tablet:wyslijfaktura', data,GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification('Nie ma komu wystawic faktury.Podejdź bliżej klienta.')	
	end

end)

RegisterNUICallback('zaplacfakture', function(data)

	ESX.ShowNotification('Oplaciles fakturę na kwotę ~g~' .. data.kwota .. '$ ~s~ wystawioną przez ~y~' .. data.pracownik)	
	TriggerServerEvent('lsc_tablet:zaplacfakture', data,steamid)
end)

RegisterNetEvent('faktury')
AddEventHandler('faktury', function(data)
	if data ~= false then
		SendNUIMessage({
			pokazfaktury = true,
			faktury = data
		})
	else
		SendNUIMessage({
			brakwynikow = true
		})
	end

end)

RegisterNetEvent('wyswietlfaktura')
AddEventHandler('wyswietlfaktura', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({
		faktura = true,
		data = data
	})
end)

RegisterNetEvent('obywatelzaplacił')
AddEventHandler('obywatelzaplacił', function(data,daneobywatela)
	if ESX.PlayerData.job.name == 'mecano' then
		ESX.ShowNotification('~o~' .. daneobywatela .. ' ~s~opłacił fakturę na ~g~ ' .. data.kwota .. '$~s~ wystawioną przez ~y~' .. data.pracownik)	
	end
end)

RegisterNUICallback('wyszukajfakture', function(data)
	TriggerServerEvent('lsc_tablet:wyszukajfakture',data)
end)





Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'mecano' or ESX.PlayerData.job.name == 'offmecano') then
			if IsControlJustPressed(0, 178) then
				if ESX.PlayerData.job.name == 'mecano' then
					ExecuteCommand('tablet_lsc')
				else
					ESX.ShowNotification("~r~Nie jesteś na służbie!")
				end
			end
		end
	end
end)




function startTabletAnimation()
	Citizen.CreateThread(function()
	  RequestAnimDict(tabletDict)
	  while not HasAnimDictLoaded(tabletDict) do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), tabletDict, tabletAnim, 4.0, -4.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	if tabletEntity == nil then
		Citizen.Wait(380)
		RequestModel(tabletModel)
		while not HasModelLoaded(tabletModel) do
			Citizen.Wait(1)
		end
		tabletEntity = CreateObject(GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(tabletEntity, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
	end
end

function stopTabletAnimation()
	if tabletEntity ~= nil then
		StopAnimTask(GetPlayerPed(-1), tabletDict, tabletAnim ,4.0, -4.0, -1, 50, 0, false, false, false)
		DeleteEntity(tabletEntity)
		tabletEntity = nil
	end
end



RegisterNUICallback('statystyki', function()
	ESX.TriggerServerCallback('lsc_tablet:statystyki', function(ils)
		print(ils["firma_iloscfaktur"])
		SendNUIMessage({
			staty = true,
			gracz_kwota = ils["gracz_kwota"],
			firma_kwota = ils["firma_kwota"],
			gracz_iloscfaktur = ils["gracz_iloscfaktur"],
			firma_iloscfaktur = ils["firma_iloscfaktur"]
		})

	end)
end)