# == Schema Information
#
# Table name: rides
#
#  id             :integer         not null, primary key
#  fusiontable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  ridedata       :text
#  centroid_lat   :float
#  centroid_lon   :float
#  bb_sw_lat      :float
#  bb_sw_lon      :float
#  bb_ne_lat      :float
#  bb_ne_lon      :float
#  user_id        :integer
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
end
