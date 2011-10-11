
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
end
