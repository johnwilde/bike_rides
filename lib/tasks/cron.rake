desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  # Launch a worker to process the Resque queue?  
  # Can this be done?
end
