require 'geo_ruby'

class Ride < ActiveRecord::Base
  belongs_to :user
  has_one :ride_detail, :dependent => :destroy
  validates :google_table_id, :ridedata, :presence  => true
  scope :by_date, :joins => "left join ride_details on ride_details.ride_id = rides.id", 
    :order => "ride_details.recorded DESC"

  delegate :total_distance, :moving_time, :avg_moving_speed, :max_speed,
    :max_elevation, :min_elevation, :elevation_gain, :recorded, 
    :recorded_localtime, to: :ride_detail

  after_create :after_create
  def after_create
    build_ride_detail
    ride_detail.update_details
  end

  def self.helpers
    ActionController::Base.helpers
  end

  def self.search(params)
    if params[:user_id]
      where(:user_id => params[:user_id]).by_date
    else
      Ride.by_date
    end
  end

  def self.new_table_ids_for_user(user, table_list_json)
    table_list_json["items"].map{|i| i["tableId"]} -
      user.table_ids
  end

  def self.get_new_ride_ids(user)
    tables=user.get_fusiontable_list
    puts "Found #{helpers.pluralize(tables["items"].length, 'table')}"
    new_table_ids = new_table_ids_for_user(user, tables)
    puts "Found #{helpers.pluralize(new_table_ids.length, 'new table')}"
    new_table_ids
  end

  def self.make_rides(ids, user)
    user_feedback = ""
    ids.each do |table_id|
      table_json = user.get_fusiontable(table_id)
      ride = make_ride_from_table(table_id, table_json, user)
      if (!ride)
        user_feedback += "Couldn't create ride: #{table_id}<br>"
      elsif (ride.ride_detail)
        user_feedback += "#{ride.ride_detail.recorded}, ID: #{ride.google_table_id}<br>"
      else
        user_feedback += "Error creating ride: #{table_id}<br>"
      end
    end 
    user_feedback
  end

  def self.make_ride_from_table(id, table, user)
    begin
      ride=nil

      puts "Making ride #{id}"
      ride=Ride.create({:google_table_id  => id,
                        :ridedata  => table, 
                        :user => user})

      if (!ride.valid?)
        puts "No ride data?"
      else
        puts "Created ride with duration: #{ride.moving_time}"
      end
    rescue
      if !ride.nil?
        ride.destroy
      end
      puts "Could not parse ride statistics"
    end
    ride
  end

end
