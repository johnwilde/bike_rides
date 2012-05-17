# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team_member do
    strava_member_id 1
    name "MyString"
    strava_team_id 1
  end
end
