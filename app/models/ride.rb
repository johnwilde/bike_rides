# == Schema Information
#
# Table name: rides
#
#  id                  :integer         primary key
#  fusiontable_id      :integer
#  created_at          :timestamp
#  updated_at          :timestamp
#  ridedata            :text
#  centroid_lat        :float
#  centroid_lon        :float
#  bb_sw_lat           :float
#  bb_sw_lon           :float
#  bb_ne_lat           :float
#  bb_ne_lon           :float
#  user_id             :integer
#  description         :text
#  total_distance      :float
#  total_time          :integer
#  moving_time         :integer
#  avg_speed           :float
#  avg_moving_speed    :float
#  max_speed           :float
#  min_elevation       :float
#  max_elevation       :float
#  elevation_gain      :float
#  max_grade           :float
#  min_grade           :float
#  recorded            :timestamp
#  private_description :text
#

# require 'geo_ruby/simple_features'
require 'geo_ruby'

class Ride < ActiveRecord::Base
  # make everything accessible
  #attr_accessible 
  belongs_to :user
  validates :fusiontable_id, :ridedata, :presence  => true
  default_scope :order  => 'rides.recorded DESC'

  def self.helpers
    ActionController::Base.helpers
  end

  def self.search(params)
    if params[:user_id]
      where(:user_id => params[:user_id])
    else
      find(:all)
    end
  end

  def self.make_rides_from_fusiontables(user)
    ft = get_fusiontable(user)
    tables=ft.show_tables
    puts "Checking for new rides."
    puts "Found #{helpers.pluralize(tables.length, 'table')}"
    new_tables = []
    tables.each do |table|
      if !find_by_fusiontable_id(table.id)
        new_tables << table
      end
    end
    out_s = []
    out_s << "Found #{helpers.pluralize(new_tables.length, 'new table')}"
    num_rides_before = Ride.count
    new_tables.each do |table|
      result = make_ride_from_table(table, user)
      if (!result.blank?)
        out_s <<  "On table #{table.id}: " + result
      end
    end 
    num_rides_after = Ride.count
    n=num_rides_after-num_rides_before
    out_s << "Created #{helpers.pluralize(n,'ride')}."
  end

  def self.make_ride_from_table(id, table, user)
    begin
      ride=nil
      attr_arr = table["rows"].collect {|r| r[1]}.grep(/mytracks/).first.split('<br>')
      geometry = table["rows"].collect {|r| r[2]}

      puts "Making ride #{id}"
      ride=user.rides.create({:fusiontable_id  => id,
                              :ridedata  => geometry.to_s})
      if (!ride.valid?)
        return "No geometry data"
      end
      ride.set_ride_attributes(attr_arr)
      ride.compute_bounding_box()
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

  def recorded_localtime
    # rides are saved using local time
    recorded
  end

  def compute_bounding_box()
    tmp = []
    max_segment = nil
    max_count = 0
    data=eval ridedata
    binding.pry
    data.each do |i|
      geo = GeoRuby::SimpleFeatures::Geometry::from_kml(i[:geometry])
      if geo.class==GeoRuby::SimpleFeatures::LineString and geo.count > max_count
        max_segment=geo
        max_count=geo.count
      end
      tmp << geo
    end
    gc=GeoRuby::SimpleFeatures::GeometryCollection.from_geometries(tmp)
    bb = gc.bounding_box
    centroid=max_segment.envelope().center
    self.update_attributes(:centroid_lat  => centroid.lat,
                           :centroid_lon  => centroid.lon,
                           :bb_sw_lat  =>  bb[0].lat,
                           :bb_sw_lon  => bb[0].lon,
                           :bb_ne_lat  =>  bb[1].lat,
                           :bb_ne_lon => bb[1].lon)
  end

  def self.description_valid?(descriptions)
    # Todo: make this robust
    descriptions.each do |d|
      return true if !d[:description].nil?
    end
    return false
  end

  def set_ride_attributes(attr_arr)
# # table["rows"].collect {|r| r[1]}.grep(/mytracks/).first.split('<br>')
# 0 # => ["Created by <a href='http://www.google.com/mobile/mytracks'>My Tracks</a> on Android.<p>Name: 08/26/2012 8:57am",
# 1 #  "Activity type: -",
# 2 #  "Description: -",
# 3 #  "Total distance: 132.20 km (82.1 mi)",
# 4 #  "Total time: 8:04:02",
# 5 #  "Moving time: 5:49:20",
# 6 #  "Average speed: 16.39 km/h (10.2 mi/h)",
# 7 #  "Average moving speed: 22.71 km/h (14.1 mi/h)",
# 8 #  "Max speed: 53.10 km/h (33.0 mi/h)",
# 9 #  "Average pace: 3.66 min/km (5.9 min/mi)",
# 10  #  "Average moving pace: 2.64 min/km (4.3 min/mi)",
# 11  #  "Fastest pace: 1.13 min/km (1.8 min/mi)",
# 12  #  "Max elevation: 439 m (1441 ft)",
# 13  #  "Min elevation: -38 m (-126 ft)",
# 14  #  "Elevation gain: 2049 m (6723 ft)",
# 15  #  "Max grade: 13 %",
# 16  #  "Min grade: -16 %",
# 17  #  "Recorded: 08/26/2012 8:57am",
    
    # hack to parse date
    datetext = attr_arr[17].split(':',2).last
    if ( datetext.include?('/') )
        datetime = DateTime.strptime( datetext, ' %m/%d/%Y %H:%M %p ')  # "02/18/2012 7:57 am"
    else
        datetime = DateTime.parse( datetext ); # "Tue Aug 23 06:32:43 PDT 2011"
    end

    attr = { 
      :total_distance => attr_arr[3].split(':').last.split(' ').first.to_f,
      :moving_time =>  Ride.timestring_to_sec(attr_arr[5].split(':',2).last),
      :avg_moving_speed => attr_arr[7].split(':').last.split(' ').first.to_f,
      :elevation_gain => attr_arr[14].split(':').last.split(' ').first.to_f,
      :recorded => datetime
    }
    binding.pry
    update_attributes!(attr)
 
  end

  def self.timestring_to_sec(time)
    sec=0
    mult=1
    t=time.split(":").reverse!
    t.each do |v|
      sec+=(v.to_i)*mult
      mult*=60
    end
    return sec
  end


end
