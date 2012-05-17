class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :strava_member_id
      t.string :name
      t.integer :strava_team_id

      t.timestamps
    end
  end
end
