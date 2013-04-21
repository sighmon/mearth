class AddCurrentTemperatureToWeatherReports < ActiveRecord::Migration
  def change
    add_column :weather_reports, :current_temperature, :float
  end
end
