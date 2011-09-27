# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  ride_id                :integer
#  email                  :string(255)
#

require 'spec_helper'

describe "User" do
  before(:each) do
    @attr = {
      :username  => "John",
      :email  => "",
      :password  => "foo",
      :password_confirmation  => "foo"
    }
  end

  it "should create a user" do
    User.create!(@attr)
  end

  describe "ride associations" do
    before(:each) do
      @user = User.create(@attr)
      @r1 = Factory(:ride, :user => @user, :created_at => 1.day.ago)
      @r2 = Factory(:ride, :user => @user, :created_at => 1.hour.ago)
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
