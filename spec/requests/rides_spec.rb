require 'spec_helper'

describe "Rides request" do
  it "shows rides to all users" do
    ride = FactoryGirl.create(:ride)
    visit ride_path(ride)
    page.should have_content("Total distance")
    page.should_not have_content("Private notes")
    page.should_not have_button("Delete Ride")
  end

  it "allows owner of ride to delete the ride" do
    user = FactoryGirl.create(:user)
    ride = FactoryGirl.create(:ride, :user => user, :recorded => 1.day.ago)
    login user
    visit ride_path(ride)
    page.should have_button("Delete Ride")
  end

  it "allows owner of ride to add notes to ride" do
    user = FactoryGirl.create(:user)
    ride = FactoryGirl.create(:ride, :user => user, :recorded => 1.day.ago)
    login user
    visit ride_path(ride)
    page.should have_content("Private Notes")
  end
end
