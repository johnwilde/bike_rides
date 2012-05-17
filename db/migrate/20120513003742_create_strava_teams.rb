class CreateStravaTeams < ActiveRecord::Migration
  def change
    create_table :strava_teams do |t|
      t.string :team_name

      t.timestamps
    end
  end
end
