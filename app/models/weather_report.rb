class WeatherReport < ActiveRecord::Base
  #TODO: get rid of average temperature
  attr_accessible :description, :latitude, :longitude, :maximum_temperature, :minimum_temperature, :name, :pressure, :sunrise, :sunset, :wind_direction, :wind_speed

  belongs_to :global_weather_report  

  def self.celcius_to_kelvin(celcius)
    return celcius+273.15
  end

  def self.cardinal_to_bearing(cardinal)
    return 0
  end

  def average_temperature
    (minimum_temperature+maximum_temperature)/2.0
  end

  def self.build_from_xml(xml)

    doc = Nokogiri.XML(xml)

    WeatherReport.new(
      description: doc.at_xpath("//atmo_opacity").text,
      minimum_temperature: celcius_to_kelvin(doc.at_xpath("//min_temp").text.to_f),
      maximum_temperature: celcius_to_kelvin(doc.at_xpath("//max_temp").text.to_f),
      wind_speed: doc.at_xpath("//wind_speed").text.to_f*1000/3600,
      wind_direction: cardinal_to_bearing(doc.at_xpath("//wind_direction").text),
      name: "Curiosity",
      pressure: doc.at_xpath("//wind_speed").text.to_f
    )
    
  end

  # json hash
  def self.build_from_hash(city)
 
    WeatherReport.new(
      description: city["weather"].first["description"],
      name: city["name"],
      latitude: city["coord"]["lat"],
      longitude: city["coord"]["lon"],
      maximum_temperature: city["main"]["temp_max"],
      minimum_temperature: city["main"]["temp_min"],
      wind_speed: city["wind"]["speed"]*1000/3600,
      wind_direction: city["wind"]["direction"],
      pressure: city["main"]["pressure"]   
    )
   
  end

end
