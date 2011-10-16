module SessionsHelper
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end 
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
end
