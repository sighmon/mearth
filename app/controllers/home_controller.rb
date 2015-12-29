require 'open-uri'

# require 'rmagick'
require 'debugger'

class HomeController < ApplicationController
  def index

    def celcius_to_kelvin(celcius)
      return celcius+273.15
    end

    def kelvin_to_celcius(kelvin)
      return kelvin-273.15
    end

    def get_mars_wx
      Rails.cache.fetch("mars_wx",:expires_in => 5.minutes) do
        open("http://cab.inta-csic.es/rems/rems_weather.xml").read
      end
    end

    def get_maas_wx
      Rails.cache.fetch("maas_wx",:expires_in => 5.minutes) do
        open("http://marsweather.ingenology.com/v1/latest/").read
      end
    end

    def get_cities_wx
      Rails.cache.fetch("cities_wx",:expires_in => 5.minutes) do
        open("http://api.openweathermap.org/data/2.5/box/city?bbox=-180,-90,180,90&cluster=yes&appid=#{ENV['OPENWEATHERMAP_API']}").read
      end
    end

    # Set meta tags
    set_meta_tags :title => "Where on Earth is the temperature similar to Mars?",
                  :description => "A 2013 NASA SpaceApps Challenge observing the temperature & wind speed on Mars and trying to match it with somewhere on Earth.",
                  :keywords => "mearth, mars, earth, spaceapps, adelaide, hackerspace, australia, spaceapps_adl, nasa, curiosity, rover",
                  :canonical => root_url,
                  :open_graph => {
                    :title => "Where on Earth is the temperature similar to Mars?",
                    :description => "A 2013 NASA SpaceApps Challenge observing the temperature & wind speed on Mars and trying to match it with somewhere on Earth.",
                    :url   => root_url,
                    :image => URI.join(root_url, view_context.image_path('mearth@2x.png')),
                    :site_name => "Mearth"
                  }

    # dummy report
    @local_wx = WeatherReport.new(
      description: "",
      name: "thinking...",
      maximum_temperature: 273.15,
      minimum_temperature: 273.15,
      wind_speed: 0,
      url: "http://openweathermap.org/Maps"
    )

    #parse mars weather data
    @mars_wx = WeatherReport.build_from_maas_v1(get_maas_wx)

    gwr = GlobalWeatherReport.build_from_hash(JSON.parse(get_cities_wx)["list"])

    min = gwr.weather_reports.min{|a,b| a.minimum_temperature <=> b.minimum_temperature}
    max = gwr.weather_reports.max{|a,b| a.maximum_temperature <=> b.maximum_temperature}
    # debugger
    @closest_wx = gwr.weather_reports.sort_by{|r| (celcius_to_kelvin(r.maximum_temperature)-@mars_wx.maximum_temperature).abs}.first
    # debugger
  end

  def localwx
    if params[:longitude].nil? or params[:latitude].nil?
      location = Geokit::Geocoders::IpGeocoder.geocode(request.remote_ip) #request.remote_ip
      longitude = location.lng
      latitude = location.lat
    else
      longitude = params[:longitude]
      latitude = params[:latitude]
    end
    openweather_result = open("http://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{ENV['OPENWEATHERMAP_API']}").read
    # debugger
    @local_wx = WeatherReport.build_from_hash(JSON.parse(openweather_result))
    @local_wx.maximum_temperature = kelvin_to_celcius(@local_wx.maximum_temperature)
    render :partial => "wx", :locals => {:wx => @local_wx, :modal => "localModal", :name => "local", :displayName => "Local"}
  end

end
