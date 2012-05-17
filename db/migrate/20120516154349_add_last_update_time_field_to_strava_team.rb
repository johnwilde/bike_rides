class AddLastUpdateTimeFieldToStravaTeam < ActiveRecord::Migration
  def change
    add_column :strava_teams, :last_update_time, :datetime
  end
end
