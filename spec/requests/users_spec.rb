require 'spec_helper'

describe "Users" do



describe "signin" do
  describe "success" do
    it "should sign a user in and out" do
      user = Factory(:user, :uid => Factory.next(:uid))

      test_login_user_with_oauth(user)
      page.should have_content('Welcome '+user.name)

      click_link('Sign Out')
      page.should_not have_content(user.name)
    end
  end

end









end
