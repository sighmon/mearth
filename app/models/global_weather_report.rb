class GlobalWeatherReport < ActiveRecord::Base
  has_many :weather_reports
  # attr_accessible :title, :body

  def self.build_from_hash(cities)
    result = GlobalWeatherReport.new
    for city in cities do
      result.weather_reports << WeatherReport.build_from_hash(city)
    end
    result
  end
end
