class RideDetail < ActiveRecord::Base
  belongs_to :ride

  def update_details
    set_attributes
    compute_bounding_box
    # puts "Created ride with duration: #{moving_time}"
    puts "Created: " + to_s
  end

  def rows
      @rows = @rows || JSON.parse(ride.ridedata)["rows"]
  end

  def to_s
    "
    google_table_id:#{ride.google_table_id}
    total_distance:#{total_distance}
    moving_time:#{moving_time}
    avg_moving_speed:#{avg_moving_speed}
    max_speed:#{max_speed}
    min_elevation:#{min_elevation}
    max_elevation:#{max_elevation}
    elevation_gain:#{elevation_gain}
    "
  end

  def compute_bounding_box
    begin
      lines = rows.collect {|r| r[2]["geometry"]}.
        keep_if {|r| r["type"] == "LineString"}
      tmp = lines.map {|i| GeoRuby::SimpleFeatures::Geometry::
                       from_geojson(i.to_json)}
      gc = GeoRuby::SimpleFeatures::GeometryCollection.from_geometries(tmp)
      bb = gc.envelope
      assign_attributes(:centroid_lat  => bb.center.lat,
                        :centroid_lon  => bb.center.lon,
                        :bb_sw_lat  => bb.lower_corner.lat,
                        :bb_sw_lon  => bb.lower_corner.lon, 
                        :bb_ne_lat  => bb.upper_corner.lat,
                        :bb_ne_lon => bb.upper_corner.lon)
    rescue
      errors[:ridedata] << "Failed while parsing geometry"
    end
  end

  def parse_v1(fields)
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
    datetext = fields[17].split(':',2).last
    datetime = parse_date(datetext)
    attr = { 
      :total_distance => fields[3].split(':').last.split(' ').first.to_f,
      :moving_time => timestring_to_sec(fields[5].split(':',2).last),
      :avg_moving_speed => fields[7].split(':').last.split(' ').first.to_f,
      :max_speed => fields[8].split(':').last.split(' ').first.to_f,
      :max_elevation => fields[12].split(':').last.split(' ').first.to_f,
      :min_elevation => fields[13].split(':').last.split(' ').first.to_f,
      :elevation_gain => fields[14].split(':').last.split(' ').first.to_f,
      :recorded => datetime
    }
  end    

  def parse_v2(fields)
# 0 "<p></p><p>Created by <a href='http://www.google.com/mobile/mytracks'>My Tracks</a> on Android.<p>Total distance: 27.12 km (16.9 mi)",
# 1 "Total time: 1:16:18",
# 2 "Moving time: 1:09:12",
# 3 "Average speed: 21.32 km/h (13.3 mi/h)",
# 4 "Average moving speed: 23.51 km/h (14.6 mi/h)",
# 5 "Max speed: 63.93 km/h (39.7 mi/h)",
# 6  "Average pace: 2.81 min/km (4.5 min/mi)",
# 7 "Average moving pace: 2.55 min/km (4.1 min/mi)",
# 8 "Min pace: 0.94 min/km (1.5 min/mi)",
# 9 "Max elevation: 222 m (730 ft)",
# 10 "Min elevation: 6 m (20 ft)",
# 11 "Elevation gain: 381 m (1251 ft)",
# 12 "Max grade: 26 %",
# 13 "Min grade: -10 %",
# 14  "Recorded: 04/03/2012 6:18 AM",
# 15  "Activity type: -",
    datetext = fields[14].split(':',2).last
    datetime = parse_date(datetext)
    attr = { 
      :total_distance => fields[0].split(':').last.split(' ').first.to_f,
      :moving_time => timestring_to_sec(fields[2].split(':',2).last),
      :avg_moving_speed => fields[4].split(':').last.split(' ').first.to_f,
      :max_speed => fields[5].split(':').last.split(' ').first.to_f,
      :max_elevation => fields[9].split(':').last.split(' ').first.to_f,
      :min_elevation => fields[10].split(':').last.split(' ').first.to_f,
      :elevation_gain => fields[11].split(':').last.split(' ').first.to_f,
      :recorded => datetime
    }
  end
  def parse_v3(fields)
# 0 "<p>Morning ride</p><p>Created by <a href='http://mytracks.appspot.com'>My Tracks</a> on Android.<p>Total Distance: 32.91 km (20.4 mi)",
# 1 "Total Time: 1:08:12",
# 2 "Moving Time: 57:29",
# 3 "Average Speed: 28.95 km/h (18.0 mi/h)",
# 4 " Average Moving Speed: 34.35 km/h (21.3 mi/h)",
# 5 " Max Speed: 65.70 km/h (40.8 mi/h)",
# 6 "Min Elevation: -10 m (-31 ft)",
# 7 "Max Elevation: 173 m (569 ft)",
# 8 "Elevation Gain: 420 m (1378 ft)",
# 9 "Max Grade: 10 %",
# 10 "Min Grade: -8 %",
# 11 "Recorded: Tue Aug 23 06:32:43 PDT 2011",
# 12 "Activity type: -",
    datetext = fields[11].split(':',2).last
    datetime = parse_date(datetext)
    attr = { 
      :total_distance => fields[0].split(':').last.split(' ').first.to_f,
      :moving_time => timestring_to_sec(fields[2].split(':',2).last),
      :avg_moving_speed => fields[3].split(':').last.split(' ').first.to_f,
      :max_speed => fields[5].split(':').last.split(' ').first.to_f,
      :max_elevation => fields[7].split(':').last.split(' ').first.to_f,
      :min_elevation => fields[6].split(':').last.split(' ').first.to_f,
      :elevation_gain => fields[8].split(':').last.split(' ').first.to_f,
      :recorded => datetime
    }
  end

  def set_attributes
    begin 
      fields = rows.collect {|r| r[1]}.grep(/mytracks/).first;
      fields = fields.gsub('\n',' ').split('<br>')
      if fields.size > 18
        attr = parse_v1(fields)
      elsif fields.size > 17
        attr = parse_v2(fields)
      else
        attr = parse_v3(fields)
      end
      assign_attributes(attr)
    rescue
      errors[:ridedata] << "Failed while parsing fields"
    end
  end

  def parse_date(datetext)
    if ( datetext.include?('/') )
      datetime = DateTime.strptime( datetext, ' %m/%d/%Y %H:%M %p ')  # "02/18/2012 7:57 am"
    else
      datetime = DateTime.parse( datetext ); # "Tue Aug 23 06:32:43 PDT 2011"
    end
  end    

  def timestring_to_sec(time)
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
