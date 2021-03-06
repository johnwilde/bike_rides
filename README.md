## Goal
A convenient web interface to the GPS track data gathered by the [My Tracks](http://mytracks.appspot.com/) application on the Android phone.  

### Features
1. Easily load ride data from Google Fusion Tables into a user’s account
2. Display maps of all the user’s rides [like this](http://maps.google.com/maps/ms?msa=0&msid=216635579959815109659.0004acea80b8bb4f5d6db) that can be easily browsed and searched
3. Allow user to attach public/private notes to each ride
4. Support for Metric and English units


### The TODO list
0. User feedback during ride import process
1. Robust search/filtering capability (currently can only search by user ID)
2. Show multiple routes on a single map
3. More interesting and customizable aggregate statistics on rides
4. Long term: provide a distribution of the elapsed time between two user-selected waypoints (across all the rides that went through those waypoints).  

### AJAX for ride import
- Click 'Import Rides'
- Request for list of ride ids that aren't in DB
- "Status: getting new rides"
- Spawn series of requests (batches of 5?) to import rides
- "Status: importing rides"
- Append new ride descriptions to page

## Data Sources:
- My ride spreadsheet
- My fusion tables as well their Google Docs counterparts
- The application’s database

## Models:
- User - has many Rides
- Ride - belongs to a User

## Implementation notes
### Displaying the maps
- Use the Google Maps Javascript API to create a Fusion Table layer (using the Fusion Table IDs from the user)
- Find centerpoint and bounding boxes for map by parsing the ride data and using the geo\_data gem.
- Pass the necessary inputs to the javascript code by setting HTML attributes in the `<div>` element where the map will be inserted.

## Getting up and running
- bundle install
- bundle exec rake db:migrate
- bundle exec rake db:test:prepare
- bundle exec thin start (for development use thin instead of webrick, works
    with the google auth)
- edit /etc/hosts file
- Postgresql is the DB, some helpful commands:
- to install (on OS X): brew install postgresql
- on Ubuntu, to create the databases:
  sudo -u postgres createdb db/test
  sudo -u postgres createdb db/development
- to get status of server: pg\_ctl status -D /usr/local/var/postgres/
- to list available databases: psql -l
- to process the background jobs that fetch Temperature data from Weather
  Underground: 
  heroku run rake jobs:work 
  Click on "Update Rides" in app (this puts rides without Temperature data on
  the queue)
- Check out the startft.rb script for using GData::FusionTables interface 
- set client secret in config/initializers from https://code.google.com/apis/console/

## General Resources ##
<http://ruby.railstutorial.org/>  
<http://bostonrb.org/presentations/write-code-faster-expert-level-vim> Good talk on using VI for Rails  
<http://railscasts.com/episodes/37-simple-search-form?autoplay=true>  
<http://railscasts.com/episodes/213-calendars?autoplay=true>  
<http://railscasts.com/episodes/174-pagination-with-ajax>  
<http://guides.rubyonrails.org/routing.html>  
<http://www.youtube.com/watch?v=0L_dEOjhADQ>  
<http://rubular.com/> The nifty reg exp playground  
<http://guides.rubyonrails.org/active_record_querying.html>  
<http://railscasts.com/episodes/51-will-paginate>  
<http://railscasts.com/episodes/132-helpers-outside-views>  
<http://railscasts.com/episodes/271-resque>  

## Authentication
<http://code.google.com/apis/accounts/docs/OpenID.html> Uses the Hybrid strategy (OpenID authentication of user + OAuth authorization for access to Fusion Tables)  
<http://railscasts.com/episodes/235-omniauth-part-1?autoplay=true>  
<http://railscasts.com/episodes/236-omniauth-part-2> At 11:30 see how to override devise password required.  
<http://railscasts.com/episodes/241-simple-omniauth>
<http://railscasts.com/episodes/151-rack-middleware?view=similar (background for omniauth)>  
<http://railscasts.com/episodes/210-customizing-devise?autoplay=true>  
<https://www.google.com/accounts/ManageDomains>  
####A working example of using omniauth with Google as a provider.  
1. First, I Googled ‘providers in omniauth’
2. using pry (cd OmniAuth::Strategies::Goo > tab complete to see all Google strategies)
3. bundle open omniauth to look at the source code
4. from a comment in the gems-open-id\*google\_hybrid file found [this example](https://github.com/boyvanamstel/Google-Hybrid-Omniauth-implementation), made by the person who wrote the provider  

## Google APIs
<http://code.google.com/apis/maps/documentation/javascript/>  
<http://code.google.com/apis/gdata/articles/gdata_on_rails.html>  
<http://code.google.com/apis/fusiontables/docs/sample_code.html>  

## Ruby wrappers for APIs
<https://github.com/tokumine/fusion_tables>  
<https://github.com/balexand/gdata_plus>  

## Other
<https://github.com/rstacruz/nakedpaper/tree/> How to set environment variables on Heroku.  
<https://github.com/jchunky/table_builder> An updated version of table\_builder that works on 3.1  
