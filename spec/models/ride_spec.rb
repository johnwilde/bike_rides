require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
    @user.save!
    testfile = File.dirname(__FILE__) + '/../support/ft-response.json'
    # json = JSON.parse(open(testfile,'r').read)
    json = open(testfile,'r').read
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
    end


    it "should parse v1" do
      testfile = File.dirname(__FILE__) + '/../support/ft-v1response.json'
      json = open(testfile,'r').read
      @attr = { :google_table_id  => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34",
                :ridedata => json}
      @ride = @user.rides.create(@attr)
      
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
    it "should parse v2" do
      testfile = File.dirname(__FILE__) + '/../support/ft-v2response.json'
      json = open(testfile,'r').read
      @attr = { :google_table_id  => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34",
                :ridedata => json}
      @ride = @user.rides.create(@attr)

# 0 "<p></p><p>Created by <a href='http://www.google.com/mobile/mytracks'>My Tracks</a> on Android.<p>Total distance: 27.12 km (16.9 mi)",
# 1 "Total time: 1:16:18",
# 2 "Moving time: 1:09:12",
# 3 "Average speed: 21.32 km/h (13.3 mi/h)",
# 4 "Average moving speed: 23.51 km/h (14.6 mi/h)",
# 5 "Max speed: 63.93 km/h (39.7 mi/h)",
# 6  "Average pace: 2.81 min/km (4.5 min/mi)",
# 7 "Average moving pace: 2.55 min/km (4.1 min/mi)",
# 8 "Min pace: 0.94 min/km (1.5 min/mi)",
# 9 "Max elevation: 222 m (730 ft)",
# 10 "Min elevation: 6 m (20 ft)",
# 11 "Elevation gain: 381 m (1251 ft)",
# 12 "Max grade: 26 %",
# 13 "Min grade: -10 %",
# 14  "Recorded: 04/03/2012 6:18 AM",
# 15  "Activity type: -",
      @ride.total_distance.should == 27.12
      @ride.moving_time.should ==  1*60*60 +9*60 + 12
      @ride.avg_moving_speed.should == 23.51
      @ride.max_speed.should == 63.93
      @ride.min_elevation.should == 6
      @ride.max_elevation.should == 222
      @ride.elevation_gain.should == 381
      @ride.recorded.should == 
        DateTime.strptime("04/03/2012 6:18 AM", '%m/%d/%Y %H:%M %p')
    end
    
    it "should parse v3" do
      testfile = File.dirname(__FILE__) + '/../support/ft-v3response.json'
      # json = JSON.parse(open(testfile,'r').read)
      json = open(testfile,'r').read
      @attr = { :google_table_id  => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34",
                :ridedata => json}
      @ride = @user.rides.create(@attr)
 # 0 "<p>Morning ride</p><p>Created by <a href='http://mytracks.appspot.com'>My Tracks</a> on Android.<p>Total Distance: 32.91 km (20.4 mi)",
 # 1 "Total Time: 1:08:12",
 # 2 "Moving Time: 57:29",
 # 3 "Average Speed: 28.95 km/h (18.0 mi/h)",
 # 4 " Average Moving Speed: 34.35 km/h (21.3 mi/h)",
 # 5 " Max Speed: 65.70 km/h (40.8 mi/h)",
 # 6 "Min Elevation: -10 m (-31 ft)",
 # 7 "Max Elevation: 173 m (569 ft)",
 # 8 "Elevation Gain: 420 m (1378 ft)",
 # 9 "Max Grade: 10 %",
 # 10 "Min Grade: -8 %",
 # 11 "Recorded: Tue Aug 23 06:32:43 PDT 2011",
 # 12 "Activity type: -",
      @ride.total_distance.should == 32.91
      @ride.moving_time.should ==  57*60 + 29
      @ride.avg_moving_speed.should == 28.95
      @ride.max_speed.should == 65.7 
      @ride.min_elevation.should == -10
      @ride.max_elevation.should == 173
      @ride.elevation_gain.should == 420
      @ride.recorded.should == 
        DateTime.strptime("Tue Aug 23 06:32:43 PDT 2011", '%a %b %d %H:%M:%S %Z %Y')
    end

    it "shoudl parse v4" do
      testfile = File.dirname(__FILE__) + '/../support/ft-v4response.json'
      json = open(testfile,'r').read
      @attr = { :google_table_id  => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34",
                :ridedata => json}
      @ride = @user.rides.create(@attr)
      @ride.total_distance.should == 27.12
      @ride.moving_time.should ==  1*60*60 +9*60 + 12
      @ride.avg_moving_speed.should == 23.51
      @ride.max_speed.should == 63.93
      @ride.min_elevation.should == 6
      @ride.max_elevation.should == 222
      @ride.elevation_gain.should == 381
      @ride.recorded.should == 
        DateTime.strptime("04/03/2012 6:18 AM", '%m/%d/%Y %H:%M %p')
    end
  end
end
