class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    sign_in (auth)
    redirect_to user_path(current_user)
  end

  def fail
    render :text  => request.to_yaml
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end

  def sign_in(auth)
    puts "CREATING SESSION"
    # User.create_with_omniauth(auth)
    user = User.find_by_uid(auth["uid"].to_s) || User.create_with_omniauth(auth)
    user.update_attributes(:token  => auth["credentials"]["token"], :secret  => auth["credentials"]["secret"])
    session[:user_id] = user.id
  end


end
