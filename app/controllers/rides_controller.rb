require 'will_paginate/array'

class RidesController < ApplicationController
  include SessionsHelper

  before_filter :authorized_user, :only => :destroy
  def new
  end

  def update
    @ride = Ride.find(params[:id])
    if @ride.update_attributes(params[:ride])
      redirect_to rides_path + "?user_id=#{@ride.user_id}", :flash => { :success => "Ride updated." }
    else
    end
  end

  def show
    @ride = Ride.find(params[:id])
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
    Ride.make_rides_from_fusiontables(current_user)
    redirect_to rides_path 
  end

  private
    def authorized_user
      @ride = current_user.rides.find_by_id(params[:id])
      redirect_to root_path if @ride.nil?
    end
end
