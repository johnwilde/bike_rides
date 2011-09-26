### FUSION TABLE API ###
#
# Using Client Login (which requires user to give me their google password)
    ft=GData::Client::FusionTables.new; 
    config=YAML::load_file(File.join(File.dirname(__FILE__),'../../credentials.yml'))
    ft.clientlogin(config["google_username"], config["google_password"])
    tables=ft.show_tables
    tables.each do |table|
      if !Ride.find_by_fusiontable_id(table.id)
        make_ride_from_table(table)
      end
    end

    # GDATA_PLUS
    # Can use gdata plus to get a listing of the tables through the 
    # Docs List API, but this doesn't allow the use of the fusion_tables interface
    request.headers.merge!({"Authorization" => helper.header})
    auth = get_authenticator(user)
    # to just get tables: https://docs.google.com/feeds/default/private/full/-/table
    response = auth.client.get("https://docs.google.com/feeds/default/private/full")
    feed=Nokogiri::XML(response.body)
    # select on entry and resourceId (in the "gd" namespace )
    res=feed.css("entry gd|resourceId")
    # filter all table entries into an array 
    tab = []
    res.each{ |i| tab<<i if i.to_s =~ /table/}
