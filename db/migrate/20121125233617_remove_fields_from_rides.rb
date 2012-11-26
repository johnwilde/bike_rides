class RemoveFieldsFromRides < ActiveRecord::Migration
  def up
    remove_column :rides, :fusiontable_id, :centroid_lat, :centroid_lon, :bb_sw_lat, :bb_sw_lon,
      :bb_ne_lat, :bb_ne_lon, :total_distance, :total_time, :moving_time, :avg_speed,
      :avg_moving_speed, :max_speed, :min_elevation, :max_elevation, :elevation_gain,
      :max_grade, :min_grade, :recorded 
  end

  def down
  end
end
