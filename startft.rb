module TestFt
  Ft=GData::Client::FusionTables.new; 
  Config=YAML::load_file(File.join(File.dirname(__FILE__),'credentials.yml'))
  Ft.clientlogin(Config["google_username"], Config["google_password"])
  Tables=Ft.show_tables
  binding.pry
  T=Tables[0]
  G=T.select "geometry"
end
