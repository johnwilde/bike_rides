class ChangeWeatherStringToTextInRide < ActiveRecord::Migration
  def up
    change_column :rides, :weather, :text
  end

  def down
    change_column :rides, :weather, :string
  end
end
