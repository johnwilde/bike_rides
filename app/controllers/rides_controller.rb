class RidesController < ApplicationController
  def new
  end

  def show
    @ride = Ride.find(params[:id])
  end

  def index
    @rides = Ride.paginate(:page  => params[:page])
  end

end
