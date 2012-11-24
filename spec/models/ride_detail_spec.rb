require 'spec_helper'

describe RideDetail do
  describe "parse ride geometry" do
    it "should parse geo data" do
      ride = FactoryGirl.create(:ride)
      ride.ride_detail.centroid_lat.should_not be_nil
    end
  end

  describe "parsing ride description text" do

    it "should parse v1" do
# 0  "Created by <a href='http://www.google.com/mobile/mytracks'>My Tracks</a> on Android.<p>Name: 08/26/2012 8:57am",
# 1  "Activity type: -",
# 2  "Description: -",
# 3  "Total distance: 132.20 km (82.1 mi)",
# 4  "Total time: 8:04:02",
# 5  "Moving time: 5:49:20",
# 6  "Average speed: 16.39 km/h (10.2 mi/h)",
# 7  "Average moving speed: 22.71 km/h (14.1 mi/h)",
# 8  "Max speed: 53.10 km/h (33.0 mi/h)",
# 9  "Average pace: 3.66 min/km (5.9 min/mi)",
# 10 "Average moving pace: 2.64 min/km (4.3 min/mi)",
# 11 "Fastest pace: 1.13 min/km (1.8 min/mi)",
# 12 "Max elevation: 439 m (1441 ft)",
# 13 "Min elevation: -38 m (-126 ft)",
# 14 "Elevation gain: 2049 m (6723 ft)",
# 15 "Max grade: 13 %",
# 16 "Min grade: -16 %",
# 17 "Recorded: 08/26/2012 8:57am",
      ride = FactoryGirl.create(:ride, :file => 'ft-v1response.json')
      ride_detail = ride.ride_detail

      ride_detail.total_distance.should == 132.20
      ride_detail.moving_time.should == 5*60*60 + 49*60 + 20
      ride_detail.avg_moving_speed.should == 22.71
      ride_detail.min_elevation.should == -38
      ride_detail.max_elevation.should == 439
      ride_detail.elevation_gain.should == 2049
      ride_detail.recorded.should == 
        DateTime.strptime("08/26/2012 8:57 am", '%m/%d/%Y %H:%M %p')
    end
    it "should parse v2" do
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
      ride = FactoryGirl.create(:ride, :file => 'ft-v2response.json')
      ride_detail = ride.ride_detail

      ride_detail.total_distance.should == 27.12
      ride_detail.moving_time.should ==  1*60*60 +9*60 + 12
      ride_detail.avg_moving_speed.should == 23.51
      ride_detail.max_speed.should == 63.93
      ride_detail.min_elevation.should == 6
      ride_detail.max_elevation.should == 222
      ride_detail.elevation_gain.should == 381
      ride_detail.recorded.should == 
        DateTime.strptime("04/03/2012 6:18 AM", '%m/%d/%Y %H:%M %p')
    end
    
    it "should parse v3" do
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
      ride = FactoryGirl.create(:ride, :file => 'ft-v3response.json')
      ride_detail = ride.ride_detail

      ride_detail.total_distance.should == 32.91
      ride_detail.moving_time.should ==  57*60 + 29
      ride_detail.avg_moving_speed.should == 28.95
      ride_detail.max_speed.should == 65.7 
      ride_detail.min_elevation.should == -10
      ride_detail.max_elevation.should == 173
      ride_detail.elevation_gain.should == 420
      ride_detail.recorded.should == 
        DateTime.strptime("Tue Aug 23 06:32:43 PDT 2011", '%a %b %d %H:%M:%S %Z %Y')
    end

    it "should parse v4" do
      ride = FactoryGirl.create(:ride, :file => 'ft-v4response.json')
      ride_detail = ride.ride_detail

      #todo: handle this bad data
    end
  end
end
