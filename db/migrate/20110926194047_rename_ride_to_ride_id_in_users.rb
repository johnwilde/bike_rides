class RenameRideToRideIdInUsers < ActiveRecord::Migration
  def up
    rename_column :users, :ride, :ride_id
  end

  def down
    rename column :users, :ride_id, :ride
  end
end
