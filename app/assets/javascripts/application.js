// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function(){
  $("div#ft_map").each(function(i){
    initialize(this);
  });
});


function initialize(element) {
  var map;

  var lat = element.getAttribute('lat');
  var lon = element.getAttribute('lon');
  var latlng = new google.maps.LatLng(lat,lon);

  var myOptions = {
    zoom: 3,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(element, myOptions);
  var sw_lat = element.getAttribute('sw_lat');
  var sw_lon = element.getAttribute('sw_lon');
  var ne_lat = element.getAttribute('ne_lat');
  var ne_lon = element.getAttribute('ne_lon');
  var latLngBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(sw_lat, sw_lon),
      new google.maps.LatLng(ne_lat, ne_lon));
  
  var layer = new google.maps.FusionTablesLayer({
    query: {
             select: 'geometry',
      from: element.getAttribute('ft_id')
           },
  });
  layer.setMap(map);
  map.fitBounds( latLngBounds );
}
