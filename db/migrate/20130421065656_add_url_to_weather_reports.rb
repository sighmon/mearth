class AddUrlToWeatherReports < ActiveRecord::Migration
  def change
    add_column :weather_reports, :url, :string
  end
end
