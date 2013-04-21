class CreateWeatherReports < ActiveRecord::Migration
  def change
    create_table :weather_reports do |t|
      t.string :name
      t.float :minimum_temperature
      t.float :maximum_temperature
      t.float :average_temperature
      t.string :description
      t.float :wind_speed
      t.float :wind_direction
      t.float :latitude
      t.float :longitude
      t.time :sunset
      t.time :sunrise
      t.float :pressure

      t.timestamps
    end
  end
end
