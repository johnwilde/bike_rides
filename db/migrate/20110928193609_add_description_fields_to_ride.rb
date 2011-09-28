class AddDescriptionFieldsToRide < ActiveRecord::Migration
  def change
    add_column :rides, :total_distance, :float
    add_column :rides, :total_time, :integer
    add_column :rides, :moving_time, :integer
    add_column :rides, :avg_speed, :float
    add_column :rides, :avg_moving_speed, :float
    add_column :rides, :max_speed, :float
    add_column :rides, :min_elevation, :float
    add_column :rides, :max_elevation, :float
    add_column :rides, :elevation_gain, :float
    add_column :rides, :max_grade, :float
    add_column :rides, :min_grade, :float
    add_column :rides, :recorded, :datetime
  end
end
