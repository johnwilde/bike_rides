namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_rides
  end
end

def make_users
  user = Factory(:user) 
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    User.create!(:name => name,
                 :email => email)
  end
end

def make_rides
  User.all(:limit => 6).each do |user|
    10.times do |n|
      ride = Factory(:ride, :user => user,
                     :description => Faker::Lorem.sentence(5),
                     :recorded => rand(100).day.ago)
      user.update_attribute(:ride_id, ride.id)
    end
  end


end
