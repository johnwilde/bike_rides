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

require 'geo_ruby'
require 'gdata_plus'
require 'nokogiri'

class Ride < ActiveRecord::Base
  # make everything accessible
  #attr_accessible 
  belongs_to :user
  validates :fusiontable_id, :ridedata, :presence  => true
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
    puts "Checking for new rides."
    puts "Found #{tables.length} tables"
    new_tables = []
    tables.each do |table|
      if !find_by_fusiontable_id(table.id)
        new_tables << table
      end
    end
    puts "Found #{new_tables.length} new tables"
    new_tables.each {|table| make_ride_from_table(table, user)}
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
            # Hack in which I assume the presence of ':' indicates summary data to parse
            # I'm doing this so I don't rely on specific words 
            if p.text.count(':') > 10
              set_attributes_from_summary_text(p.text)
            # Leave this check for now, although it won't work for non-english users.
            elsif (p.text =~ /^Created by My Tracks/) != 0
              update_attribute(:description, p.text)
            end
          end
        end
      end
    end
  end

  def set_attributes_from_summary_text(text)
    # remove the time strings like 2:23  or 23:32:22
    re=/\d+:\d+:*\d*/
    a=text.gsub(re,"")
    b=text.scan(re)  # save the matches for parsing later

    # this regexp finds numbers like: 1.23 or or -3 or +3
    a=a.scan(/[+-]?\d*\.?,?\d+/)
    s=[]
    s[0]=a[0]
    s[1]=a[2] 
    s[2]=a[4] 
    s[3]=a[6] 
    s[4]=a[8]
    s[5]=a[10]
    s[6]=a[12]
    s[7]=a[14]
    s[8]=a[15]
    s.each {|n| n.sub!(",",".")}

    attr={ :total_distance  => s[0],
           :total_time  => Ride.timestring_to_sec(b[0]),
           :moving_time  => Ride.timestring_to_sec(b[1]),
           :avg_speed  => s[1],
           :avg_moving_speed => s[2],
           :max_speed => s[3],
           :min_elevation => s[4],
           :max_elevation => s[5],
           :elevation_gain => s[6],
           :max_grade => s[7],
           :min_grade => s[8],
           :recorded => text.split("%").last.to_datetime }

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
