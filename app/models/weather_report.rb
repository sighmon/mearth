class WeatherReport < ActiveRecord::Base
  #TODO: get rid of average temperature
  attr_accessible :description, :latitude, :longitude, :maximum_temperature, :minimum_temperature, :name, :pressure, :sunrise, :sunset, :wind_direction, :wind_speed, :url, :current_temperature

  belongs_to :global_weather_report  

  def self.celcius_to_kelvin(celcius)
    return celcius+273.15
  end

  # not implemented yet
  def self.cardinal_to_bearing(cardinal)
    case cardinal
      when "N"
        return 0
      when "E"
        return 90
      when "S"
        return 180
      when "W"
        return 270
      else
        return 0
    end
  end

  def average_temperature
    (minimum_temperature+maximum_temperature)/2.0
  end
 
  # for data from http://cab.inta-csic.es/rems/rems_weather.xml
  def self.build_from_xml(xml)

    doc = Nokogiri.XML(xml)

    WeatherReport.new(
      description: doc.at_xpath("//atmo_opacity").text,
      minimum_temperature: celcius_to_kelvin(doc.at_xpath("//min_temp").text.to_f),
      maximum_temperature: celcius_to_kelvin(doc.at_xpath("//max_temp").text.to_f),
      wind_speed: doc.at_xpath("//wind_speed").text.to_f,
      wind_direction: cardinal_to_bearing(doc.at_xpath("//wind_direction").text),
      name: "Curiosity",
      pressure: doc.at_xpath("//wind_speed").text.to_f,
      url: "https://cab.inta-csic.es/rems/marsweather.html"
    )
    
  end

  # json hash from openweathermap.com
  def self.build_from_hash(city)
 
    WeatherReport.new(
      description: city["weather"].first["description"],
      name: city["name"],
      latitude: city["coord"]["lat"],
      longitude: city["coord"]["lon"],
      current_temperature: city["main"]["temp"],
      maximum_temperature: city["main"]["temp_max"],
      minimum_temperature: city["main"]["temp_min"],
      wind_speed: city["wind"]["speed"]*1000/3600,
      wind_direction: city["wind"]["direction"],
      pressure: city["main"]["pressure"],
      url: "http://openweathermap.org/city/%s" % city["id"]
    )
   
  end

  # for stream from http://marsweather.ingenology.com/
  def self.build_from_maas_v1(json)

    report = JSON.parse(json)["report"]
 
    WeatherReport.new(
      description: report["atmo_opacity"],
      name: "Curiosity",
      maximum_temperature: celcius_to_kelvin(report["max_temp"]),
      minimum_temperature: celcius_to_kelvin(report["min_temp"]),
      wind_speed: report["wind_speed"],
      wind_direction: report["wind_direction"],
      wind_direction: cardinal_to_bearing(report["wind_direction"]),
      pressure: report["pressure"],
      url: "http://marsweather.ingenology.com"
    )
   
  end
  

end
