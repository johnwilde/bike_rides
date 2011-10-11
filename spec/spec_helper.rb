require 'spork'
require 'capybara/rspec'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, comment the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = true

    def test_configure_oauth_for_user(user, service = :google_hybrid)
      credentials=
      {"scope"=>["https://www.google.com/fusiontables/api/query"],
       "token"=>"test_token",
       "secret"=>"test_secret"}
      user_info= {"name" => user.name,
                  "email" => user.email}
      OmniAuth.config.add_mock(:google_hybrid, 
                               {:uid => user.uid,
                                "credentials" => credentials,
                                "user_info" => user_info})
    end
    
    def test_login_user_with_oauth(user, service = :google_hybrid)
      test_configure_oauth_for_user(user, service)
      visit "/auth/#{service}"
    end
  end

  OmniAuth.config.test_mode = true
end

Spork.each_run do
end
