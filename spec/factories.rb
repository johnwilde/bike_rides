Factory.define :user do |user|
  user.name                  "John A Wilde"
  user.email                 "mhartl@example.com"
end

Factory.define :ride do |ride|
  ride.fusiontable_id "123123"
  ride.association :user
end
