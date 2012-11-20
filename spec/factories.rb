FactoryGirl.define do
  factory :user do 
    name "Test User"
    email "testuser@gmail.org"
    provider   "google_oauth2"
    sequence(:uid) { |n| n }
    credentials  {{"token"=>"ya29.AHES6ZR2ZxXlXtduasdD9C0suKGQUxIlkWCt-6b6_lKMCQ", "refresh_token"=>"1/UZDu8DHlrB-1vf6vT945K8cfRxILZKiAou6HQqLZBvo", "expires_at"=>1348469521, "expires"=>true}}
    extra_raw_info {{"id"=>"104009305006165168598", "email"=>"johnwilde@gmail.com", "verified_email"=>true, "name"=>"John Wilde", "given_name"=>"John", "family_name"=>"Wilde", "link"=>"https://plus.google.com/104009305006165168598", "picture"=>"https://lh4.googleusercontent.com/-FC2gR_Eh7FI/AAAAAAAAAAI/AAAAAAAAGCw/nudXajQVy50/photo.jpg", "gender"=>"male", "birthday"=>"0000-08-24", "locale"=>"en-US"}}
  end

  factory :ride  do
    google_table_id     "1Egw_xFIEnkrzUEvbt4O9-rs2U6VG09vxYgRNH34"
    association :user
    ridedata {JSON.parse(open(File.dirname(__FILE__) + '/support/ft-response-small.json','r').read)}
  end

  sequence :uid do |n|
    SecureRandom.hex(16)
  end

end

