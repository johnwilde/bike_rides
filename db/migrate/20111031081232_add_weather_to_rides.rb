class AddWeatherToRides < ActiveRecord::Migration
  def change
    add_column :rides, :weather, :text
  end
end
