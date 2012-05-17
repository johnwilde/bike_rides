require 'spec_helper'
describe TeamMember do
  before(:each) do
    api = MockApi.new(1)
    TeamMember.class_variable_set(:@@api, api )
    StravaTeam.class_variable_set(:@@api, api )
    @team_member = Factory(:team_member)
  end

  it "should create new team member" do
    @attr = {:strava_member_id => 2207, :name => 'john'}
    TeamMember.create!(@attr)
  end
  
  it "should update a members rides" do
    @team_member.team_rides.count.should == 0
    @team_member.update_rides
    @team_member.team_rides.count.should == 2
  end

  it "should delete rides from a previous month" do
    @team_member.team_rides.create({:strava_ride_id => 1, :elevation_gain => 0, :start_date => Time.now - 1.month})
    @team_member.team_rides.count.should == 1
    @team_member.update_rides
    @team_member.team_rides.count.should == 2
  end

  it "should delete a ride that was removed from strava" do
    @team_member.update_rides
    @team_member.team_rides.count.should == 2
    mock_api = MockApi.new(1)
    mock_api.drop_ride # remove a ride from the api
    TeamMember.class_variable_set(:@@api, mock_api)
    @team_member.update_rides
    @team_member.team_rides.count.should == 1

  end
end
