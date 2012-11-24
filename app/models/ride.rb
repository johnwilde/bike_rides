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

  def self.make_rides_from_fusiontables(user)
    tables=user.get_fusiontable_list

    puts "Checking for new rides."
    puts "Found #{helpers.pluralize(tables["items"].length, 'table')}"

    new_table_ids = new_table_ids_for_user(user, tables)

    puts "Found #{helpers.pluralize(new_table_ids.length, 'new table')}"

    num_rides_before = Ride.count

    new_table_ids.each do |table_id|
      table_json = user.get_fusiontable(table_id)
      result = make_ride_from_table(table_id, table_json, user)
      if (!result.blank?)
        puts "On table #{table.id}: " + result
      end
    end 

    num_rides_after = Ride.count
    n=num_rides_after-num_rides_before
    "Created #{helpers.pluralize(n,'ride')}."
  end

  def self.make_ride_from_table(id, table, user)
    begin
      ride=nil

      puts "Making ride #{id}"
      ride=Ride.create({:google_table_id  => id,
                        :ridedata  => table, :user => user})

      if (!ride.valid?)
        return "No geometry data"
      end
    rescue
      if !ride.nil?
        ride.destroy
      end
      return "Could not parse ride statistics"
    else
      puts "Created ride with duration: #{ride.moving_time}"
      return ""
    end
  end

end
