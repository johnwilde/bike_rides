# == Schema Information
#
# Table name: rides
#
#  id               :integer         not null, primary key
#  fusiontable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  ridedata         :text
#  centroid_lat     :float
#  centroid_lon     :float
#  bb_sw_lat        :float
#  bb_sw_lon        :float
#  bb_ne_lat        :float
#  bb_ne_lon        :float
#  user_id          :integer
#  description      :text
#  total_distance   :float
#  total_time       :integer
#  moving_time      :integer
#  avg_speed        :float
#  avg_moving_speed :float
#  max_speed        :float
#  min_elevation    :float
#  max_elevation    :float
#  elevation_gain   :float
#  max_grade        :float
#  min_grade        :float
#  recorded         :datetime
#

require 'geo_ruby'
require 'gdata_plus'
require 'nokogiri'

class Ride < ActiveRecord::Base
  # make everything accessible
  #attr_accessible 
  belongs_to :user
  validates :fusiontable_id, :presence  => true
  default_scope :order  => 'rides.recorded DESC'

  def self.search(params)
    if params[:user_id]
      where(:user_id => params[:user_id])
    else
      find(:all)
    end
  end

  def self.make_rides_from_fusiontables(user)
    authenticator = get_authenticator(user)
    gdataplus_client=GDataPlus::Client.new(authenticator, "3.0")
    ft=GData::Client::FusionTables.new
    ft.auth_handler=authenticator
    tables=ft.show_tables
    tables.each do |table|
      if !find_by_fusiontable_id(table.id)
        make_ride_from_table(table, user)
      end
    end

    puts "Checking for new rides."
  end

  def self.get_authenticator(user)
    GDataPlus::Authenticator::OAuth.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :access_token => user.token,
      :access_secret => user.secret
    )
  end

  def self.make_ride_from_table(table, user)
    geometry = table.select "geometry"
    descriptions = table.select "description"

    puts "Making ride #{table.id}"
    ride=user.rides.create({:fusiontable_id  => table.id,
                            :ridedata  => geometry.to_s})

    ride.set_ride_attributes(descriptions)

    ride.compute_bounding_box()
    binding.pry
    puts "Created ride with duration: #{ride.moving_time}"
  end

  def compute_bounding_box()
    tmp = []
    max_segment = nil
    max_count = 0
    data=eval ridedata
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

  def set_ride_attributes(descriptions)
    descriptions.each do |d|
      if !d.nil?
        ptag=Nokogiri::HTML(d[:description]).css("p")
        ptag.each do |p|
          if ( !p.nil? )
            if p.text =~ /^Total Distance/ 
              set_attributes_from_summary_text(p.text)
            elsif (p.text =~ /^Created by My Tracks/) != 0
              update_attribute(:description, p.text)
            end
          end
        end
      end
    end
  end

  def set_attributes_from_summary_text(text)
    # remove stuff inside parens
    text.gsub!(/\([^)]*\)/, "")
    ["Total Distance:","Total Time:","Moving Time:",
     "Average Speed:","Average Moving Speed:",
     "Max Speed:","Min Elevation:","Max Elevation:",
     "Elevation Gain:","Max Grade:","Min Grade:",
     "Recorded:","Activity type:"].each do |s|
       text.gsub!(s,",")
     end
    ["km/h", "%", "km", "m"].each {|s| text.gsub!(s,"")}
  
    text = text.split(",")

    attr={ :total_distance  => text[1],
           :total_time  => Ride.timestring_to_sec(text[2]),
           :moving_time  => Ride.timestring_to_sec(text[3]),
           :avg_speed  => text[4],
           :avg_moving_speed => text[5],
           :max_speed => text[6],
           :min_elevation => text[7],
           :max_elevation => text[8],
           :elevation_gain => text[9],
           :max_grade => text[10],
           :min_grade => text[11],
           :recorded => text[12].to_datetime}
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
