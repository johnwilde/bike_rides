# == Schema Information
#
# Table name: users
#
#  id               :integer         primary key
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  created_at       :timestamp
#  updated_at       :timestamp
#  token            :string(255)
#  secret           :string(255)
#  admin            :boolean         default(FALSE)
#  ride_id          :integer
#  email            :string(255)
#  use_metric_units :boolean
#

require 'spec_helper'

describe "User" do

  before(:each) do
    @attr = {
      :name  => "John",
      :email  => "blah@mail.com",
    }
  end

  it "should create a user from omniauth hash" do
    omniauth = {"provider" => "google_hybrd", "uid" => "123", "user_info" => {}, "credentials" => {}}
    omniauth["user_info"] = 
      {"name" => "MyName",
       "email" => "myemail@google.com"}

    @user = User.create_with_omniauth(omniauth)
    @user.email.should eq("myemail@google.com")
    @user.uid.should eq(123)
    @user.name.should eq("MyName")
  end

  it "has admin attribute set to false" do
    @user = User.create(@attr)
    @user.admin?.should eq(false)
  end

  describe "ride associations" do
    before(:each) do
      @user = User.create(@attr)
      @r1 = Factory(:ride, :user => @user, :recorded => 1.day.ago)
      @r2 = Factory(:ride, :user => @user, :recorded => 1.hour.ago)
    end

    it "should have the rides in the right order" do
      @user.rides.should == [@r2, @r1]
    end

    it "should destroy associated rides" do
      @user.destroy
      [@r1, @r2].each do |r|
        Ride.find_by_id(r.id).should be_nil
      end
    end
  end
end
