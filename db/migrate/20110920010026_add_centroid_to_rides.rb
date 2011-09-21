class AddCentroidToRides < ActiveRecord::Migration
  def change
    add_column :rides, :centroid, :string
  end
end
