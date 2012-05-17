class CreateTeamRides < ActiveRecord::Migration
  def change
    create_table :team_rides do |t|
      t.integer :strava_ride_id
      t.integer :elevation_gain
      t.integer :team_member_id

      t.timestamps
    end
  end
end
