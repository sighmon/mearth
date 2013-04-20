require 'open-uri'

require 'RMagick'

class HomeController < ApplicationController
  def index
    def celcius_to_kelvin(celcius)
      return celcius+273
    end

    cities = JSON.parse(open("http://openweathermap.org/data/2.1/find/city?format=json&bbox=-180,-90,180,90").read)
  
    min = cities["list"].min{|a,b| (a["main"].try(:[],"temp_min").to_f) <=> (b["main"].try(:[],"temp_min").to_f)}["main"]["temp_min"].to_f
    max = cities["list"].max{|a,b| (a["main"].try(:[],"temp_max").to_f) <=> (b["main"].try(:[],"temp_max").to_f)}["main"]["temp_max"].to_f

    @mars_min = celcius_to_kelvin(-69)
    @mars_max = celcius_to_kelvin(3)
 
    @mars_avg = (@mars_min+@mars_max)/2.0

    def avg(city)
      return (city["main"].try(:[],"temp_min").to_f+city["main"].try(:[],"temp_max").to_f)/2.0
    end

    @closest = cities["list"].min do |a,b| 

      def dist(city)
        return (avg(city)-@mars_max).abs
      end

      dist(a) <=> dist(b)
    end

    @closest_avg = avg(@closest)
  
    #logger.info(@closest)

    height = cities["list"].length

    canvas = Magick::Image.new(max, height,
              Magick::HatchFill.new('white','lightcyan2')) 
    canvas.format = "JPEG"
    gc = Magick::Draw.new

    #gc.stroke('transparent')
    #gc.fill('#202123')
    #gc.pointsize('11')
    #gc.font_family = "helvetica"
    #gc.font_weight = Magick::BoldWeight
    #gc.font_style  = Magick::NormalStyle
    #cities["list"].each{|c| gc.text(x=c["coord"]["lon"]+180,y=c["coord"]["lat"]+90,text=c["name"])}
    #cities["list"].each{|c| gc.point(x=c["coord"]["lon"]+180,y=90-c["coord"]["lat"])}

    gc.stroke("red")
    gc.line(@mars_min,0,@mars_min,height)
    gc.line(@mars_max,0,@mars_max,height)

    @index=0
    cities["list"].each do |c| 
      if (c==@closest)
        gc.stroke("pink")
        gc.line(0,@index,max,@index)
      end
      gc.stroke("black")
      gc.line(c["main"]["temp_min"],@index,c["main"]["temp_max"],@index)

      gc.fill("green")
      gc.stroke("green")
      #logger.info(avg(c))
      gc.point(avg(c),@index)
      #fscking evil
      @index+=1
    end
    #gc.text(x = 83, y = 14, text = "foobar")
    gc.draw(canvas)
    
    @data_uri = Base64.encode64(canvas.to_blob).gsub(/\n/, "")  
  end
end
