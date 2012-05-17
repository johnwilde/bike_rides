# See: https://github.com/stevenchanin/strava-api/issues/3
module Crack
  class JSON
    def self.parse(json)
      require 'json'
      return JSON(json)
    end
  end
end

class TeamMember < ActiveRecord::Base
  attr_accessible :name, :strava_member_id
  belongs_to :strava_team
  has_many :team_rides, :dependent => :destroy

  @@api = StravaApi::Base.new

  def elevation_total
    team_rides.sum(:elevation_gain)
  end

  def ride_count
    team_rides.count
  end

  def elevation_average
    return 0 if ride_count == 0
    elevation_total / ride_count
  end

  def update_rides
    puts "process member #{name}"

    # we only care about data from the current month
    start_of_month = Date.new(Date.today.year, Date.today.month, 1)

    offset = 0
    ride_ids = [] #collect the ride ids here
    while (rides = @@api.rides(:athlete_id => strava_member_id,
                               :start_date => start_of_month, 
                               :offset => offset)) && !rides.empty? do
        puts "process #{rides.size} rides"
        #work on this set of rides
        rides.each do |ride|
          ride_ids.push(ride.id)
          # ignore rides that we've already processed
          next if team_rides.find_by_strava_ride_id(ride.id)
          puts "processing #{ride.id}"
          ride_info = @@api.ride_show(ride.id)
          team_rides.create({:strava_ride_id => ride_info.id, 
                             :elevation_gain => ride_info.elevation_gain, 
                             :start_date => ride_info.start_date})
        end

        #retrieve next set of rides for this member
        puts "getting next set of rides"
        offset += rides.size
    end

    # find and destroy any rides that are no longer needed
    # This could be because they are from a previous month or the ride
    # was removed from strava
    current_ride_ids = team_rides.collect {|ride| ride.strava_ride_id }
    rides_to_delete = current_ride_ids - ride_ids 

    team_rides.find(:all, :conditions => { :strava_ride_id => rides_to_delete }).map {|i| i.destroy}
  end
end
