# == Schema Information
#
# Table name: rides
#
#  id             :integer         not null, primary key
#  fusiontable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  ridedata       :text
#  centroid_lat   :float
#  centroid_lon   :float
#  bb_sw_lat      :float
#  bb_sw_lon      :float
#  bb_ne_lat      :float
#  bb_ne_lon      :float
#  user_id        :integer
#

require 'geo_ruby'
require 'gdata_plus'
require 'nokogiri'

class Ride < ActiveRecord::Base
  # make everything accessible
  #attr_accessible 
  belongs_to :user
  validates :fusiontable_id, :presence  => true

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

    puts "Making ride #{table.id}"
    ride=user.rides.create({:fusiontable_id  => table.id,
                            :ridedata  => geometry.to_s})

    ride.compute_bounding_box()
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

end
