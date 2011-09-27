require 'openid/store/filesystem'

if Rails.env == 'production'
  CONSUMER_SECRET =  ENV['OAUTH_SECRET']
  CONSUMER_KEY = ENV['OAUTH_KEY']
else
  config = YAML::load_file(File.join(File.dirname(__FILE__), 'credentials.yml'))
  CONSUMER_SECRET = config['secret'] 
  CONSUMER_KEY = config['key']
end

# :scope => ["https://docs.google.com/feeds/", "https://spreadsheets.google.com/feeds/"], 
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_hybrid, OpenID::Store::Filesystem.new('/tmp'), 
    :name => 'google_hybrid',
    :identifier => 'https://www.google.com/accounts/o8/id', 
    :scope  => ["https://www.google.com/fusiontables/api/query"],
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET
end
