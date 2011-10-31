class AddWeatherToRide < ActiveRecord::Migration
  def change
    add_column :rides, :weather, :string
  end
end
