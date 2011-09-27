require 'will_paginate/array'

class RidesController < ApplicationController
  def new
  end

  def show
    @ride = Ride.find(params[:id])
  end

  def index
    @results = Ride.search(params)
    @rides = @results.paginate(:page => params[:page], :per_page => 4)
  end

  def updateall
    Ride.make_rides_from_fusiontables(current_user)
    redirect_to rides_path 
  end
end
