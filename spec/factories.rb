Factory.define :user do |user|
  user.name "Test User"
  user.email "testuser@gmail.org"
  user.provider   "google_hybrid"
  user.uid "uid"
end

Factory.sequence :uid do |n|
  SecureRandom.hex(16)
end

Factory.define :ride do |ride|
  ride.fusiontable_id     "123123"
  ride.association :user
  #ride.user_id             :integer
  ride.ridedata '[{:geometry=>"<Point><coordinates>-122.170504,37.424195,13.0</coordinates></Point>"}, {:geometry=>"<LineString><coordinates>-122.170504,37.424195,13.0 -122.170533,37.423975,16.20</coordinates></LineString>"}, {:geometry=>"<Point><coordinates>-122.171136,37.360698,270.79998779296875</coordinates></Point>"}]'
  ride.centroid_lat       "37.4"
  ride.centroid_lon       "-122.16" 
  ride.bb_sw_lat          "37.36"   
  ride.bb_sw_lon          "-122.17" 
  ride.bb_ne_lat          "37.42"   
  ride.bb_ne_lon          "-122.15" 
  ride.description        "description"
  ride.total_distance     "1.5"  
  ride.total_time         "1"    
  ride.moving_time        "1"    
  ride.avg_speed          "10"   
  ride.avg_moving_speed   "10"
  ride.max_speed          "10" 
  ride.min_elevation      "10" 
  ride.max_elevation      "10" 
  ride.elevation_gain     "10" 
  ride.max_grade          "10" 
  ride.min_grade          "10" 
  ride.recorded           "2011-10-07 02:30:44.000000"  
  ride.private_description     "private note"
end
