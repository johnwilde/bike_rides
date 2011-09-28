# == Schema Information
#
# Table name: rides
#
#  id               :integer         not null, primary key
#  fusiontable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  ridedata         :text
#  centroid_lat     :float
#  centroid_lon     :float
#  bb_sw_lat        :float
#  bb_sw_lon        :float
#  bb_ne_lat        :float
#  bb_ne_lon        :float
#  user_id          :integer
#  description      :text
#  total_distance   :float
#  total_time       :integer
#  moving_time      :integer
#  avg_speed        :float
#  avg_moving_speed :float
#  max_speed        :float
#  min_elevation    :float
#  max_elevation    :float
#  elevation_gain   :float
#  max_grade        :float
#  min_grade        :float
#  recorded         :datetime
#

require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :fusiontable_id  => "123456" }
  end
  
  it "should create a new instance given valid attributes" do
    @user.rides.create!(@attr)
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

  describe "parsing ride description text" do
    before(:each) do 
      @ride = @user.rides.create(@attr)
      @text = "Total Distance: 32.91 km (20.4 mi)Total Time: 1:08:12Moving Time: 57:29Average Speed: 28.95 km/h (18.0 mi/h) Average Moving Speed: 34.35 km/h (21.3 mi/h) Max Speed: 65.70 km/h (40.8 mi/h)Min Elevation: -10 m (-31 ft)Max Elevation: 173 m (569 ft)Elevation Gain: 420 m (1378 ft)Max Grade: 10 %Min Grade: -8 %Recorded: Tue Aug 23 06:32:43 PDT 2011Activity type: -"
    end

    it "should parse fields" do
      @ride.set_attributes_from_summary_text(@text)
      @ride.total_distance.should == 32.91
      @ride.total_time.should==1*3600+8*60+12
      @ride.moving_time.should==57*60+29
      @ride.avg_speed.should==28.95
      @ride.avg_moving_speed.should==34.35
      @ride.max_speed.should==65.70
      @ride.min_elevation.should==-10
      @ride.max_elevation.should==173
      @ride.elevation_gain.should==420
      @ride.max_grade.should==10
      @ride.min_grade.should==-8
      @ride.recorded.should==DateTime.parse("Tue Aug 23 06:32:43 PDT 2011")
    end

  end
end
