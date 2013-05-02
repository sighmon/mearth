
function success(position) {
  $(function() {
    console.log("setting position");
    console.log(position);
    $("#localModal").data("longitude",position.coords.longitude);
    $("#localModal").data("latitude",position.coords.latitude);
  });

  // instead of this we should re-gen the _wx block with ajax.
  // (in which case the modal should be nested inside the top div)
}

function buildMap(modal) {
  latitude = $(modal).data("latitude");
  longitude = $(modal).data("longitude");
  var latlng = new google.maps.LatLng(latitude, longitude);
  var myOptions = {
    zoom: 12,
    center: latlng,
    mapTypeControl: false,
    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map($(modal).find(".mapCanvas")[0], myOptions);
  

  var marker = new google.maps.Marker({
      position: latlng, 
      map: map, 
  });

}

$(function(){
  $(".mapCanvas").parent().parent().on("shown",function(){
    console.log("shown",this);
    buildMap(this);
  });
});

function error(msg) {
  //var s = document.querySelector('#status');
  //s.innerHTML = typeof msg == 'string' ? msg : "failed";
  //s.className = 'fail';
  
  console.log("Error",msg);
}

if (Modernizr.geolocation) {
  //navigator.geolocation.getCurrentPosition(success, function(){success({"coords":{"latitude":16.775833,"longitude":-3.009444,"accuracy":0}})});
  navigator.geolocation.getCurrentPosition(success, error, {timeout:3000});
} else {
  error('not supported');
}

