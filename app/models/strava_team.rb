require 'strava-api'

class StravaTeam < ActiveRecord::Base
  attr_accessible :team_name, :strava_id, :last_update_time
  has_many :team_members, :dependent  => :destroy
  validates(:team_name, presence: true)
  @@api = StravaApi::Base.new

  def self.search_strava_for_team_name(search_string)
    clubs = @@api.clubs(search_string)
    return nil if clubs.empty?
    #just pick the first matching club
    details = @@api.club_show(clubs.first.id)
    {:team_name => details.name, :strava_id => details.id}
  end

  def update_members
    # load the club members
    members = @@api.club_show(strava_id).members

    # array of club member IDs
    ids_latest = members.map{ |m| m.id }
    # array of club member IDs that we already had 
    ids_saved = team_members.map{ |m| m.strava_member_id }

    # find the IDs of any members who aren't in the club any more
    ids_delete = ids_saved - ids_latest
    ids_delete.each do |id|
      team_members.find_by_strava_member_id(id).destroy
    end

    # create team members that we don't have yet 
    members.each do |member|
      if !team_members.find_by_strava_member_id(member.id)
        team_members.create({:strava_member_id => member.id,
                             :name => member.name})
      end
    end
      
    # finally, update the rides for all the team members
    team_members.each {|m| m.update_rides}

    # update attribute to show last time we updated this club
    self[:last_update_time]= Time.now
    save

  end

end
