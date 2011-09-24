require 'geo_ruby'

class RidesController < ApplicationController
  def new
  end

  def show
    @ride = Ride.find(params[:id])
  end

  def index
    @rides = Ride.paginate(:page => params[:page], :per_page => 4)
    @ride = Ride.new
  end

  def updateall
    Ride.make_rides_from_fusiontables(current_user)
    redirect_to rides_path 
  end
end
