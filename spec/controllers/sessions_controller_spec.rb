require 'spec_helper'

describe SessionsController do
  before do
    @user = Factory(:user, :uid => Factory.next(:uid))
    test_configure_oauth_for_user(@user)
    request.env["omniauth.auth"]=OmniAuth.config.mock_auth[:google_hybrid]
  end

  describe "GET 'new'" 

  describe "POST 'create'" do
    describe "success" do
      it "should sign the user in" do
        post :create
        controller.current_user.should == @user   
        controller.should be_signed_in
      end
      it "should redirect to the user show page" do
        post :create
        response.should redirect_to(user_path(@user))
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      post :create
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
