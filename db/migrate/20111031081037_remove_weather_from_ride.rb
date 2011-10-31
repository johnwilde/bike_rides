class RemoveWeatherFromRide < ActiveRecord::Migration
  def up
    remove_column :rides, :weather
  end

  def down
    add_column :rides, :weather, :text
  end
end
