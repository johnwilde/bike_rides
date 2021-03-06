require 'spec_helper'

describe "Users request" do

  it "shows profile" do
    user = FactoryGirl.create(:user)
    visit user_path(user)
    page.should have_content(user.name)
    page.should_not have_button("Update Rides")
  end


  it "logs in a user" do
    user = FactoryGirl.create(:user)
    login user  #see auth_macros in support folder 
    visit user_path(user)  
    page.should have_button("Update Rides")
    page.should have_content('Welcome '+user.name)

    click_link('Sign Out')
    page.should_not have_content(user.name)
  end

  it "logs out a user" do
    user = FactoryGirl.create(:user)
    login user
    visit signout_path(user)
    visit user_path(user)
    page.should_not have_button("Update Rides")
  end


  it "deletes a user" do
    user = FactoryGirl.create(:user)
    login user
    visit users_path
    page.should have_content ("delete")
    click_link ("delete")
  end

end
