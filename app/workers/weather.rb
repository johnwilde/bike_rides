require 'open-uri'
require 'json'
require 'yaml'

if Rails.env == 'production'
  WUNDERGROUND_KEY = ENV['WUNDERGROUND_KEY']
else
  config = YAML::load_file(File.join(File.dirname(__FILE__), '../../config/initializers/credentials.yml'))
  WUNDERGROUND_KEY = config['wunderground'] 
end

class Weather
  @queue = :weather_queue
  def self.perform
    rides = Ride.has_detail.where(:weather => nil)
    puts "Processing #{rides.size} rides"
    rides.each_index do |i|
      # limit API calls to 10/minute
      if (i>0 and (i%10).zero?)
        puts "Sleeping..."
        sleep 60.seconds
      end

      obs = self.get_weather(rides[i].recorded_localtime, 
                             rides[i].ride_detail.centroid_lat, 
                             rides[i].ride_detail.centroid_lon )
      rides[i].weather = obs.to_json 
      rides[i].save
      puts "Ride id=#{rides[i].id} was recorded when it was #{obs['tempi']} deg F"
    end

  end

  def self.get_weather( datetime, lat, lon )
    date_string = datetime.strftime("%Y%m%d")
    url = 'http://api.wunderground.com/api/' + WUNDERGROUND_KEY + 
      '/history_' + date_string + '/geolookup/conditions/q/' + 
      lat.to_s + ',' + lon.to_s + '.json'
    puts "query: #{url}"

    open(url) do |f| 
      json_string = f.read 
      parsed_json = JSON.parse(json_string) 
      observation = self.get_best_observation(
        parsed_json['history']['observations'], 
        datetime.hour, 
        datetime.min) 
      return observation
    end
  end
  
  def self.get_best_observation( history, hour, min )
    if min > 30 then 
      hour = hour + 1
    end
    record = history[1]
    history.each do |h|
      if (h['date']['hour'].to_i - hour).abs < (record['date']['hour'].to_i - hour).abs then
        record = h
      end
    end

    return record
  end
end
