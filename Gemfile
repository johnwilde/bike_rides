source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'gdata_plus', :git  => 'git://github.com/johnwilde/gdata_plus.git'

gem 'jquery-rails'
gem 'sqlite3'
gem "therubyracer"
gem 'fusion_tables', :git  => 'git://github.com/johnwilde/fusion_tables.git'
gem 'will_paginate', :git  => 'git://github.com/mislav/will_paginate.git'
gem 'GeoRuby'
gem 'omniauth'
gem 'table_builder', '0.0.3', :git => 'git://github.com/jchunky/table_builder.git' 

group :development do
  # user mongrel web server to handle the large oauth requests
  gem 'mongrel'
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
  gem "rb-inotify"
end

group :production do
  gem 'pg'
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

