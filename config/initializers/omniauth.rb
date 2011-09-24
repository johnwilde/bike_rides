require 'openid/store/filesystem'
CONSUMER_SECRET =  'nGrCLyH_rUpbrXSe3U1ZMsVT'
CONSUMER_KEY = 'johnwilde.us'
# :scope => ["https://docs.google.com/feeds/", "https://spreadsheets.google.com/feeds/"], 
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_hybrid, OpenID::Store::Filesystem.new('/tmp'), 
    :name => 'google_hybrid',
    :identifier => 'https://www.google.com/accounts/o8/id', 
    :scope  => ["https://www.google.com/fusiontables/api/query"],
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET
end
