Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google, 'johnwilde.us', 'nGrCLyH_rUpbrXSe3U1ZMsVT'
end
