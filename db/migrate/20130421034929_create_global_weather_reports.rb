class CreateGlobalWeatherReports < ActiveRecord::Migration
  def change
    create_table :global_weather_reports do |t|
      t.references :weather_report

      t.timestamps
    end
    add_index :global_weather_reports, :weather_report_id
  end
end
