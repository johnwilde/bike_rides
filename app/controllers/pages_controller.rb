class PagesController < ApplicationController

  def home
    @title = "Home"
    if signed_in?
      redirect_to user_path(current_user) 
    end
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
end
