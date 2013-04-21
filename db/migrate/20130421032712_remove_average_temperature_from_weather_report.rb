class RemoveAverageTemperatureFromWeatherReport < ActiveRecord::Migration
  def up
    remove_column :weather_reports, :average_temperature
  end

  def down 
    add_column :weather_reports, :average_temperature, :float
  end
end
