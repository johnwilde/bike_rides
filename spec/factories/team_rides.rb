# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team_ride do
    strava_ride_id 1
    elevation_gain 1
    team_member_id 1
  end
end
