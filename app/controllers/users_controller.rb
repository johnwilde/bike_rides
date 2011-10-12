class UsersController < ApplicationController

  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name

    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @rides = @user.rides
  end

  def new
    @user  = User.new
    @title = "Sign up"
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
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed." }
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end
end
