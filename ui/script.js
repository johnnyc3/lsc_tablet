$(document).ready(function(){
  $('.container').css('display', 'none')
  window.addEventListener("message", function(event){
    if(event.data.brakwynikow == true){
      $NOTIFICATION({
        wynik: false,
      });

    }

    if(event.data.pokazfaktury == true){
      var faktury = event.data.faktury
      faktury.forEach(function (item){
        $NOTIFICATION({
          pracownik: item.pracownik,
          klient: item.dostajacy,
          kwota: item.kwota,
          powod: item.powod,
          id: item.id,
          wynik: true,
        });
        
      });
    }
    if(event.data.staty == true){
      const staty = event.data


      document.getElementById("firma-faktury").innerHTML = numberWithSpaces(Number(staty.firma_iloscfaktur))
    
      document.getElementById("gracz-faktury").innerHTML = numberWithSpaces(Number(staty.gracz_iloscfaktur))
    
      document.getElementById("gracz-kasa").innerHTML = numberWithSpaces(Number(staty.gracz_kwota)) + ' $'
    
      document.getElementById("firma-kasa").innerHTML = numberWithSpaces(Number(staty.firma_kwota)) + ' $'



    }
    if(event.data.showhud == true){
      $('.niefaktura').css('display', 'block');
      $('.faktura').css('display', 'none');  
      $('.container').css('display', 'block')

      const player = event.data.player
      


      document.getElementById("player").innerHTML ='Zalogowano jako: ' + player;




      $('#logout').css('display', 'block')
      $('#footer').css('display', 'block')
      $('#title').css('font-size', '60px')
      $('#faktura_btn').css('display', 'block')
      $('#szukajfakture_btn').css('display', 'block')
      $('#statystyki_btn').css('display', 'block')

      $('.statystyki').css('display', 'none')
      $('#powod_faktura').css('display', 'none')
      $('#minicontainer_faktura').css('display', 'none')
      $('#btn_faktura').css('display', 'none')
      $('#kwota_faktura').css('display', 'none')
      document.getElementById("title").innerHTML = 'Los Santos Customs'
      $('#anulujfakture').css('display', 'none')
    }
    if(event.data.faktura == true){



      const faktura = event.data.data
      document.getElementById("title").innerHTML ='Faktura od: <div id="pracownik">' + faktura.pracownik + "</div>";
      document.getElementById("hajs").innerHTML = faktura.kwota;
      document.getElementById("powod_faktura").innerHTML = faktura.powod;
      document.getElementById("steamid").innerHTML = faktura.steamid;

      $('#title').css('font-size', '40px')
      $('#powod_faktura').css('display', 'block')

      $('#minicontainer_faktura').css('display', 'block')
      $('#btn_faktura').css('display', 'block')
      $('#kwota_faktura').css('display', 'block')
      
      $('.container').css('display', 'block')
      $('.menu').css('display', 'block')
      $('.btn').css('display', 'none');  
      $('#anulujfakture').css('display', 'block')
      $('#powod').css('display', 'none')
      $('#kwota').css('display', 'none')

      $('#logout').css('display', 'none')
      $('#footer').css('display', 'none');  
      $('.niefaktura').css('display', 'none');
      // $('.faktura').css('display', 'block');  
    }
    if(event.data.showhud == false){
      $('.container').css('display', 'none')
    }
  });
});


function numberWithSpaces(x) {
  var parts = x.toString().split(".");
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  return parts.join(".");
}

function wylacztablet() {
  $('.container').css('display', 'none')
  $.post('http://lsc_tablet/wylacztablet', JSON.stringify({}));
}
function anulujfakture(){
  $('.container').css('display', 'none')
  $.post('http://lsc_tablet/anulujfakture', JSON.stringify({}));
}

function wyslijfaktura() { 
  $.post('http://lsc_tablet/wyslijfaktura', JSON.stringify({
    powod: document.getElementById('powod').value,
    kwota: document.getElementById('kwota').value,
  }));
  wylacztablet();
}
function zaplacfakture() {
  $('.container').css('display', 'none')
  console.log("test")
  $.post('http://lsc_tablet/zaplacfakture', JSON.stringify({
    powod: document.getElementById("powod_faktura").innerText,
    kwota: document.getElementById("hajs").innerText,
    pracownik: document.getElementById("pracownik").innerText,
    steamid: document.getElementById("steamid").innerText
  }));

  $.post('http://lsc_tablet/anulujfakture', JSON.stringify({}));
}
function szukajfakture() {
  $('#title').css('display', 'block');
  $('.checkboxy-container').css('display', 'block');  
  document.getElementById("title").innerHTML ='Lista wystawionych faktur';
  $('.statystyki').css('display', 'none')
  $('.informacje').css('display', 'none');
  $('.searchbar').css('display', 'none');
  $('.t_button').css('display', 'none');  
  $('.faktura').css('display', 'none');
  $('.szukajfaktury_bary').css('display', 'block');
  $('#search_button').css('display', 'block');

  $('#powod').css('display', 'none');
  $('#wystawfakture_btn').css('display', 'none');
  $('#kwota').css('display', 'none');
}

function statystyki() {
  $('#title').css('display', 'block');
  document.getElementById("title").innerHTML ='Statystyki';
  $('#powod').css('display', 'none');
  $('.checkboxy-container').css('display', 'none'); 
  $('.informacje').css('display', 'none');
  $('.searchbar').css('display', 'none');
  $('.t_button').css('display', 'none');  
  $('.faktura').css('display', 'none');
  $('.statystyki').css('display', 'block')

  $.post('http://lsc_tablet/statystyki', JSON.stringify({}));
}



function wystawfakture() {
  $('.statystyki').css('display', 'none')
  $('#title').css('display', 'block');
  $('.checkboxy-container').css('display', 'none'); 
  document.getElementById("title").innerHTML ='Wystaw fakture';
  $('#powod').css('display', 'block');
  $('.informacje').css('display', 'none');
  $('.searchbar').css('display', 'none');
  $('.t_button').css('display', 'none');  
  $('.faktura').css('display', 'none');
  $('#wystawfakture_btn').css('display', 'block');
  $('#kwota').css('display', 'block');
}

function wyszukajwbazie_faktura() {
  var opcja = 0
  $('.faktura').css('display', 'none');
  $('.informacje').css('display', 'none');
  $('.lista').css('display', 'block');

  if (document.getElementById('checkbox-pracownik').checked) {
    opcja = 1
  }
  if (document.getElementById('checkbox-klient').checked) {
    opcja = 2
  }
  if (document.getElementById('checkbox-id').checked) {
    opcja = 3
  }
  




if (opcja != 3){
  if(document.getElementById('szukajfakture_bar').value.length > 4){
    $.post('http://lsc_tablet/wyszukajfakture', JSON.stringify({
   dane: document.getElementById('szukajfakture_bar').value,
    opcja: opcja,
  }));
}
}else{
  if(document.getElementById('szukajfakture_bar').value.length > 0){
    $.post('http://lsc_tablet/wyszukajfakture', JSON.stringify({
   dane: document.getElementById('szukajfakture_bar').value,
    opcja: opcja,
  }));
}
}

}

var input = document.getElementById("szukajfakture_bar");
input.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    event.preventDefault();
    document.getElementById("search_button").click();
  }
});

$("input:checkbox").on('click', function() {
  // in the handler, 'this' refers to the box clicked on
  var $box = $(this);
  if ($box.is(":checked")) {
    // the name of the box is retrieved using the .attr() method
    // as it is assumed and expected to be immutable
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    // the checked state of the group/box on the other hand will change
    // and the current value is retrieved using .prop() method
    $(group).prop("checked", false);
    $box.prop("checked", true);
  } else {
    $box.prop("checked", false);
  }
});


$NOTIFICATION = function (DATA) {
  let id = $(`.notification`).length + 1;
  if (DATA["wynik"]){
    let $notification = $(
      `<div class="faktura" id="${id}">
        <i class="icon-user"></i>Klient: ${DATA["klient"]} <i class="icon-wrench"></i> Pracownik:  ${DATA["pracownik"]} <i class="icon-dollar"></i> Kwota na fakturze: ${DATA["kwota"]}$
        <br/><i class="icon-clipboard"></i>Wykonane uslugi: <br/>${DATA["powod"]}
        <div class="faktura-id">
        Faktura nr.: #${DATA["id"]}
        </div>
      
      
      
      </div>`
    ).css('display', 'block').appendTo(`.lista`);
    return $notification;
  } else {
    let $notification = $(
      `<div style="background-color: red;" class="faktura" id="${id}">
     Brak wyników
      
      
      
      </div>`
    ).css('display', 'block').appendTo(`.lista`);
    return $notification;
  }

};