source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'ruby-openid'
gem 'jquery-rails'
gem 'therubyracer'
gem 'fusion_tables', :git  => 'git://github.com/johnwilde/fusion_tables.git'
gem 'will_paginate', :git  => 'git://github.com/mislav/will_paginate.git'
gem 'georuby'
gem 'dbf' #needed by georuby
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'table_builder', '0.0.3', :git => 'git://github.com/jchunky/table_builder.git' 
gem 'cancan'
gem 'resque', :require => "resque/server"
gem 'redis'
gem 'pg'
gem 'httparty', '0.6.1'
gem 'strava-api'
gem 'jquery-datatables-rails', :git => 'git://github.com/rweng/jquery-datatables-rails'
gem 'google-api-client'

group :development do
  # user mongrel web server to handle the large oauth requests
  gem 'thin'
  gem 'nifty-generators'
  gem 'rspec-rails', '2.6.1'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'faker', '0.3.1'
  gem 'pry'
  gem 'factory_girl_rails'
end

group :test do
  # Pretty printed test output
  gem 'rspec-rails', '2.6.1'
  gem 'capybara'
  gem 'turn', :require => false
  gem 'factory_girl_rails'
  gem 'pry'
  gem "guard-rspec"
  gem "spork", "> 0.9.0.rc"
  gem "guard-spork"
end

group :production do
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

