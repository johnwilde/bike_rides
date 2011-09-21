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
#
require 'geo_ruby'

class Ride < ActiveRecord::Base
  # make everything accessible
  #attr_accessible 
  

  validates :fusiontable_id, :presence  => true

  def self.make_rides_from_fusiontables
    binding.pry
    puts "Checking for new rides."
    ft=GData::Client::FusionTables.new; 
    config=YAML::load_file(File.join(File.dirname(__FILE__),'../../credentials.yml'))
    ft.clientlogin(config["google_username"], config["google_password"])
    tables=ft.show_tables
    tables.each do |table|
      if !Ride.find_by_fusiontable_id(table.id)
        make_ride_from_table(table)
      end
    end

  end

  def self.make_ride_from_table(table)
    geometry = table.select "geometry"

    puts "Making ride #{table.id}"
    ride=Ride.create({:fusiontable_id  => table.id,
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
