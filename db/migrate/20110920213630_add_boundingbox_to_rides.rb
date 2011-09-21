class AddBoundingboxToRides < ActiveRecord::Migration
  def change
    add_column :rides, :bb_sw_lat, :float
    add_column :rides, :bb_sw_lon, :float
    add_column :rides, :bb_ne_lat, :float
    add_column :rides, :bb_ne_lon, :float
  end
end
