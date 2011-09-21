namespace :db do
 desc "populate database with fusiontable data"
 task :populate  => :environment do 
   Rake::Task['db:reset'].invoke
   Ride.make_rides_from_fusiontables
   
 end
end

