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
    ride = FactoryGirl.create(:ride, :user => user)
    login user
    visit ride_path(ride)
    page.should have_button("Delete Ride")
  end

  it "allows owner of ride to add notes to ride" do
    user = FactoryGirl.create(:user)
    ride = FactoryGirl.create(:ride, :user => user)
    login user
    visit ride_path(ride)
    page.should have_content("Private Notes")
  end
  it "shows temperature of ride if it exists" do
    ride=Factory(:ride)
    visit ride_path(ride)
    # how do you test for a match with the HTML "&deg;" symbol?
    # here I just skip those two chars
    page.html.should match /28\.0..C/
  end

  it "still shows ride if weather data isn't there" do
    ride=Factory(:ride, :weather => nil)
    visit ride_path(ride)
    page.should have_content("Total distance")
  end
  # it "renders javascript" do
  #   user = FactoryGirl.create(:user)
  #   login user
  #   visit ride_path(ride)
  # end
end
