class CreateRideDetails < ActiveRecord::Migration
  def change
    create_table :ride_details do |t|
      t.integer   :ride_id
      t.float     :centroid_lat
      t.float     :centroid_lon
      t.float     :bb_sw_lat
      t.float     :bb_sw_lon
      t.float     :bb_ne_lat
      t.float     :bb_ne_lon
      t.text      :description
      t.float     :total_distance
      t.integer   :total_time
      t.integer   :moving_time
      t.float     :avg_speed
      t.float     :avg_moving_speed
      t.float     :max_speed
      t.float     :min_elevation
      t.float     :max_elevation
      t.float     :elevation_gain
      t.float     :max_grade
      t.float     :min_grade
      t.datetime  :recorded
      t.text      :private_description
      t.text      :weather

      t.timestamps
    end
  end
end
