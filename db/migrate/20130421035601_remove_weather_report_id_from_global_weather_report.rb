class RemoveWeatherReportIdFromGlobalWeatherReport < ActiveRecord::Migration
 def up
    remove_column :global_weather_reports, :weather_report_id
  end

  def down 
    add_column :global_weather_reports, :weather_report_id, :references
  end
end
