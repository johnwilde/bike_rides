class AddRidedataToRides < ActiveRecord::Migration
  def change
    add_column :rides, :ridedata, :text
  end
end
