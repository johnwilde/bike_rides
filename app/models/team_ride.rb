class TeamRide < ActiveRecord::Base
  attr_accessible :strava_ride_id, :elevation_gain, :start_date
end
