class AddRideDetailToRide < ActiveRecord::Migration
  def change
    add_column :ride_details, :ride_detail_id, :integer
  end
end
