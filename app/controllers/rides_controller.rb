require 'will_paginate/array'

class RidesController < ApplicationController
  # The CanCan gem loads the resource into an instance  variable
  # https://github.com/ryanb/cancan
  load_and_authorize_resource

  def update
    if @ride.update_attributes(params[:ride])
      redirect_to rides_path + "?user_id=#{@ride.user_id}", 
        :flash => { :success => "Ride updated." }
    else
    end
  end

  def show
    # render :json => @ride.ridedata
  end

  def index
    @results = Ride.search(params).reject{|r| r.ride_detail == nil} 
    @rides = @results.paginate(:page => params[:page], :per_page => 4)
  end

  def destroy
    user_id = @ride.user_id
    @ride.destroy
    redirect_to rides_path + "?user_id=#{user_id}"
  end

  def updateall
    @new_ids = Ride.get_new_ride_ids(current_user)
    respond_to do |format|
      format.js
    end
    # Resque.enqueue(Weather)
  end

  def new
    result = Ride.make_rides(params[:ids], current_user)
    render :text => result
  end

end
