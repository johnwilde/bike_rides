class ApplicationController < ActionController::Base
  include SessionsHelper 

  protect_from_forgery

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

end
