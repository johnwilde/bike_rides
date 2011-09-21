class AddCentroidlatlonToRides < ActiveRecord::Migration
  def change
    add_column :rides, :centroid_lat, :float
    add_column :rides, :centroid_lon, :float
  end
end
