
class SessionsController < ApplicationController
  def create
    sign_in
    redirect_to user_path(current_user), :notice => "Signed in!"
  end


  def fail
    render :text  => request.to_yaml
  end

  
  def destroy
    sign_out
    redirect_to root_url, :notice => "Signed out!"
  end
end
