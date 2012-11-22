require 'spec_helper'

describe StravaTeam do
  
  before(:each) do
    api = MockApi.new(2)
    StravaTeam.class_variable_set(:@@api, api)
    TeamMember.class_variable_set(:@@api, api)
      
    @strava_team = FactoryGirl.create(:strava_team)
    @attr = {:team_name => 'coretech', :strava_id => 2207}
  end

  it "should search strava for a team" do
    StravaTeam.search_strava_for_team_name('blah').should eq @attr
  end
  
  it "should create a new team" do
    StravaTeam.create!(@attr)
  end

  it "should require a name" do
    no_name_team = StravaTeam.new(@attr.merge({:team_name => ""}) )
    no_name_team.should_not be_valid
  end

  it "should create new members" do
    @strava_team.team_members.count.should == 0
    @strava_team.update_members
    @strava_team.team_members.count.should == 2
  end

  it "should not create duplicate members" do 
    @strava_team.team_members.count.should == 0
    @strava_team.update_members
    @strava_team.team_members.count.should == 2
    # add a member to the club
    StravaTeam.class_variable_set(:@@api, MockApi.new(3))
    @strava_team.update_members
    @strava_team.team_members.count.should == 3
  end

  it "should delete members that don't exist anymore" do
    @strava_team.team_members.count.should == 0
    @strava_team.update_members
    @strava_team.team_members.count.should == 2
    # remove  a member from the club 
    StravaTeam.class_variable_set(:@@api, MockApi.new(1))
    @strava_team.update_members
    @strava_team.team_members.count.should == 1
  end
end
