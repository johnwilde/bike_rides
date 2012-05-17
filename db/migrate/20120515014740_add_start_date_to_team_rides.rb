class AddStartDateToTeamRides < ActiveRecord::Migration
  def change
    add_column :team_rides, :start_date, :datetime
  end
end
