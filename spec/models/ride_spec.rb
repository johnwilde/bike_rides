require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
    @user.save!
    testfile = File.dirname(__FILE__) + '/../support/ft-response.json'
    json = JSON.parse(open(testfile,'r').read)
    @attr = { :google_table_id  => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34",
              :ridedata => json}
    
  end
  
  it "should create a new ride" do
    @user.rides.create!(@attr)
  end
  
  it "should require ridedata" do
    no_ridedata_ride = @user.rides.new(@attr.merge(:ridedata => ""))
    no_ridedata_ride.should_not be_valid
  end

  describe "creating multiple rides from fusion table list" do
    before(:each) do
      testfile = File.dirname(__FILE__) + '/../support/ft-list.json'
      @table_list = JSON.parse(open(testfile,'r').read)
    end
    it "gets array of table ids for rides we don't have" do
      @user.rides.create!(@attr)
      Ride.new_table_ids_for_user(@user, @table_list).should ===
        ["18HLxJVyuRA9qRXzqzJ94aouo9ZkyC9lQZ4ORCbA"]
    end
  end

  describe "user associations" do
    before(:each) do
      @ride = @user.rides.create(@attr)
    end
    
    it "should have a user attribute" do
      @ride.should respond_to(:user)
    end

    it "should have the right associated user" do
      @ride.user_id.should == @user.id
      @ride.user.should == @user
    end
  end

  describe "parse ride geometry" do
    it "should parse geo data" do
      ride = @user.rides.create(@attr)
      ride.centroid_lat.should_not be_nil
    end
  end

  describe "parsing ride description text" do
    before(:each) do 
      @ride = @user.rides.create(@attr)
    end

    it "should parse fields latest version (english)" do
      text = "Name: 
      08/26/2012 8:57am
      Activity type:
      -Description: 
      -Total distance: 132.20 km (82.1 mi)
      Total time: 8:04:02
      Moving time: 5:49:20
      Average speed: 16.39 km/h (10.2 mi/h)
      Average moving speed: 22.71 km/h (14.1 mi/h)
      Max speed: 53.10 km/h (33.0 mi/h)
      Average pace: 3.66 min/km (5.9 min/mi)
      Average moving pace: 2.64 min/km (4.3 min/mi)
      Fastest pace: 1.13 min/km (1.8 min/mi)
      Max elevation: 439 m (1441 ft)
      Min elevation: -38 m (-126 ft)
      Elevation gain: 2049 m (6723 ft)
      Max grade: 13 %
      Min grade: -16 %
      Recorded: 08/26/2012 8:57am"

      @ride.total_distance.should == 132.20
      @ride.moving_time.should == 5*60*60 + 49*60 + 20
      @ride.avg_moving_speed.should == 22.71
      @ride.min_elevation.should == -38
      @ride.max_elevation.should == 439
      @ride.elevation_gain.should == 2049
      @ride.recorded.should == 
        DateTime.strptime("08/26/2012 8:57 am", '%m/%d/%Y %H:%M %p')
    end
  end
end
