
Factory.define :user do |user|
  user.username                  "John A Wilde"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :ride do |ride|
  ride.fusiontable_id "123123"
  ride.association :user
end
