class UsersController < ApplicationController
  before_filter :load_current_user, :only => [:edit, :update]

  # The CanCan gem loads the resource into an instance  variable
  # https://github.com/ryanb/cancan
  load_and_authorize_resource
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def show
    @title = @user.name
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @rides = @user.rides
  end

  def new
  end
  
  def login
    session[:return_to] = params[:return_to] if params[:return_to]
    if Rails.env.development?
      session[:user_id] = User.first.id
      redirect_to_target_or_default root_url, :notice => "Signed in successfully"
    else
      redirect_to "/auth/google_hybrid"
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
    end
  end

  def destroy
    if @user == current_user
      sign_out
    end
    @user.destroy
    redirect_to root_url, :flash => { :success => "User destroyed." }
  end

  private

  def load_current_user
    @user = current_user
  end
end
