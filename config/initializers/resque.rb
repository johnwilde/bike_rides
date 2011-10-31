Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }

ENV["REDISTOGO_URL"] = 'redis://johnwilde:b9046870bc080ac78697f7802d9c810d@perch.redistogo.com:9521/'
uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
