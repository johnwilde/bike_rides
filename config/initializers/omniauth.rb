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
  provider :google_oauth2, CONSUMER_KEY, CONSUMER_SECRET,
    :identifier => 'https://www.google.com/accounts/o8/id', 
    :scope  => "fusiontables.readonly,userinfo.email,userinfo.profile"
    # :client_id => CONSUMER_KEY,
    # :client_secret => CONSUMER_SECRET
end
