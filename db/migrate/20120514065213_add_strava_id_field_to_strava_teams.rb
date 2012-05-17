class AddStravaIdFieldToStravaTeams < ActiveRecord::Migration
  def change
    add_column :strava_teams, :strava_id, :integer
  end
end
