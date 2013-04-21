class AddGlobalWeatherReportIdToWeatherReports < ActiveRecord::Migration
  def change
    add_column :weather_reports, :global_weather_report_id, :integer
  end
end
