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
    

    # Data from a foreign user
   @text2= "Distancia total: 3,90 km (2,4 mi)Tiempo total: 22:58Tiempo en movimiento: 16:55Velocidad promedio: 10,19 km/h (6,3 mi/h) Velocidad promedio en movimiento: 13,84 km/h (8,6 mi/h) Velocidad máxima: 20,70 km/h (12,9 mi/h)Elevación mínima: 90 m (295 ft)Elevación máxima: 130 m (425 ft)Aumento de elevación: 19 m (61 ft)Pendiente máxima: 5 %Pendiente mínima: -3 %Grabado: dom jun 19 13:26:13 GMT+02:00 2011Tipo de actividad: -".encode!(Encoding::US_ASCII,{:undef => :replace} )





