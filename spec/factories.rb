FactoryGirl.define do
  factory :user do 
    name "Test User"
    email "testuser@gmail.org"
    provider   "google_oauth2"
    sequence(:uid) { |n| n }
  end

  factory :ride  do
    google_table_id     "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34"
    association :user
    ridedata '[{:geometry=>"<Point><coordinates>-122.170504,37.424195,13.0</coordinates></Point>"}, {:geometry=>"<LineString><coordinates>-122.170504,37.424195,13.0 -122.170533,37.423975,16.20</coordinates></LineString>"}, {:geometry=>"<Point><coordinates>-122.171136,37.360698,270.79998779296875</coordinates></Point>"}]'
    centroid_lat       "37.4"
    centroid_lon       "-122.16" 
    bb_sw_lat          "37.36"   
    bb_sw_lon          "-122.17" 
    bb_ne_lat          "37.42"   
    bb_ne_lon          "-122.15" 
    description        "description"
    total_distance     "1.5"  
    total_time         "1"    
    moving_time        "1"    
    avg_speed          "10"   
    avg_moving_speed   "10"
    max_speed          "10" 
    min_elevation      "10" 
    max_elevation      "10" 
    elevation_gain     "10" 
    max_grade          "10" 
    min_grade          "10" 
    recorded           "2011-10-07 02:30:44.000000"  
    private_description     "private note"
  end

  sequence :uid do |n|
    SecureRandom.hex(16)
  end

end

