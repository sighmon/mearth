# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

get_location = ->
  if Modernizr.geolocation
    navigator.geolocation.getCurrentPosition show_map
  else
# no native support; maybe try a fallback?