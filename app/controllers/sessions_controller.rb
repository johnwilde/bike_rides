
class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    user.update_attributes(:token  => auth["credentials"]["token"], :secret  => auth["credentials"]["secret"])
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end


  def fail
    render :text  => request.to_yaml
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
