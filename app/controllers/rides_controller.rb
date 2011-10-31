require 'will_paginate/array'

class RidesController < ApplicationController
  # The CanCan gem loads the resource into an instance  variable
  # https://github.com/ryanb/cancan
  load_and_authorize_resource

  def update
    if @ride.update_attributes(params[:ride])
      redirect_to rides_path + "?user_id=#{@ride.user_id}", :flash => { :success => "Ride updated." }
    else
    end
  end

  def show
  end

  def index
    @results = Ride.search(params)
    @rides = @results.paginate(:page => params[:page], :per_page => 4)
  end

  def destroy
    user_id = @ride.user_id
    @ride.destroy
    redirect_to rides_path + "?user_id=#{user_id}"
  end

  def updateall
    if !Rails.env.development?
      result = Ride.make_rides_from_fusiontables(current_user)
    end
    Resque.enqueue(Weather)
    redirect_to :back, :notice  => result
  end

end
