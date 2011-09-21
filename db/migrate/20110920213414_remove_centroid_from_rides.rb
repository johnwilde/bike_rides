class RemoveCentroidFromRides < ActiveRecord::Migration
  def up
    remove_column :rides, :centroid
  end

  def down
    add_column :rides, :centroid, :text
  end
end
