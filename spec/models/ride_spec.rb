require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = FactoryGirl.attributes_for(:ride, :user => @user)   
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
      @attr.merge!({:google_table_id => "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34"})
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

end
