require 'open-uri'

require 'RMagick'

class HomeController < ApplicationController
  def index

    def celcius_to_kelvin(celcius)
      return celcius+273.15
    end

    def get_mars_wx
      Rails.cache.fetch("mars_wx",:expires_in => 5.minutes) do
        open("http://cab.inta-csic.es/rems/rems_weather.xml").read
      end
    end

    def get_cities_wx
      Rails.cache.fetch("cities_wx",:expires_in => 5.minutes) do
        open("http://openweathermap.org/data/2.1/find/city?format=json&bbox=-180,-90,180,90").read
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

    # logger.info request.remote_ip
    user_location = Geokit::Geocoders::IpGeocoder.geocode(request.remote_ip) #request.remote_ip
    # logger.info user_location

    local_openweather_api = open("http://api.openweathermap.org/data/2.1/find/city?lat=#{user_location.lat}&lon=#{user_location.lng}&cnt=1").read
    @local_wx = JSON.parse(local_openweather_api)
    # logger.info @local_wx


    #parse mars weather data
    @mars_wx = WeatherReport.build_from_xml(get_mars_wx)

    gwr = GlobalWeatherReport.build_from_hash(JSON.parse(get_cities_wx)["list"])

    min = gwr.weather_reports.min{|a,b| a.minimum_temperature <=> b.minimum_temperature}
    max = gwr.weather_reports.max{|a,b| a.maximum_temperature <=> b.maximum_temperature}

    @closest = gwr.weather_reports.min do |a,b| 

      def dist(city)
        return (city.maximum_temperature-@mars_wx.maximum_temperature).abs
      end

      dist(a) <=> dist(b)
    end
  
    #logger.info(@closest)

    #height = cities["list"].length

    #canvas = Magick::Image.new(max, height,
    #          Magick::HatchFill.new('white','lightcyan2')) 
    #canvas.format = "JPEG"
    #gc = Magick::Draw.new

    ##gc.stroke('transparent')
    ##gc.fill('#202123')
    ##gc.pointsize('11')
    ##gc.font_family = "helvetica"
    ##gc.font_weight = Magick::BoldWeight
    ##gc.font_style  = Magick::NormalStyle
    ##cities["list"].each{|c| gc.text(x=c["coord"]["lon"]+180,y=c["coord"]["lat"]+90,text=c["name"])}
    ##cities["list"].each{|c| gc.point(x=c["coord"]["lon"]+180,y=90-c["coord"]["lat"])}

    #gc.stroke("red")
    #gc.line(@mars_min,0,@mars_min,height)
    #gc.line(@mars_max,0,@mars_max,height)

    #
    ##@index=0
    ##cities["list"].each do |c| 
    ##  if (c==@closest)
    ##    gc.stroke("pink")
    ##    gc.line(0,@index,max,@index)
    ##  end
    ##  gc.stroke("black")
    ##  gc.line(c["main"]["temp_min"],@index,c["main"]["temp_max"],@index)

    ##  gc.fill("green")
    ##  gc.stroke("green")
    ##  #logger.info(avg(c))
    ##  gc.point(avg(c),@index)
    ##  #fscking evil
    ##  @index+=1
    ##end
    ###gc.text(x = 83, y = 14, text = "foobar")
    ##gc.draw(canvas)
    #
    #@data_uri = Base64.encode64(canvas.to_blob).gsub(/\n/, "")  
  end
end
