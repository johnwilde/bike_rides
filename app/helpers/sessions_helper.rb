module SessionsHelper
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end 
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def sign_in(auth)
    puts "CREATING SESSION"
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    user.update_attributes(:token  => auth["credentials"]["token"], :secret  => auth["credentials"]["secret"])
    session[:user_id] = user.id
    self.current_user = user
  end

  def sign_out
    puts "DESTROYING SESSION"
    session[:user_id] = nil
    self.current_user = nil
  end
end
