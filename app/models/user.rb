require 'google/api_client'

if Rails.env == 'production'
  GOOGLE_ID = ENV['GOOGLE_ID']
  GOOGLE_SECRET = ENV['GOOGLE_SECRET']
else
  config = YAML::load_file(File.join(File.dirname(__FILE__), '../../config/initializers/credentials.yml'))
  GOOGLE_ID = config['google_id'] 
  GOOGLE_SECRET = config['google_secret'] 
end

class User < ActiveRecord::Base
 has_many :rides, :dependent  => :destroy
 serialize :extra_raw_info 
 serialize :credentials

 def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.credentials = auth["credentials"]
      user.extra_raw_info = auth["extra"]["raw_info"]
    end
  end

  def table_ids
    rides.map(&:google_table_id)
  end

  # TODO: handle errors such as "invalid credentials"
  def get_fusiontable_list
    result = google_api_client.execute(
      :api_method => google_api.to_h['fusiontables.table.list'],
      :parameters => {"maxResults" => 1000}, 
      :merged_body => '',
      :headers => [['Content-Type', 'application/json']]
    )
    JSON.parse(result.response.body)
  end

  def get_fusiontable(table_id)
    # puts "doing sqlGet...#{parameters}"
    result = google_api_client.execute(
      :api_method => google_api.to_h['fusiontables.query.sqlGet'],
      :parameters => {"sql" => "select * from #{table_id}"},
      :merged_body => '',
      :headers => [['Content-Type', 'application/json']]
    )
    # open(table_id+'.json', 'w').write(result.response.body)
    result.response.body
  end
  def google_api_client
    return @api_client unless !@api_client
    @api_client = Google::APIClient.new
    @api_client.authorization.scope = 
      "scope: https://www.googleapis.com/auth/fusiontables.readonly"
    @api_client.authorization.client_id = GOOGLE_ID
    @api_client.authorization.client_secret = GOOGLE_SECRET
    @api_client.authorization.access_token = credentials["token"]
    @api_client.authorization.refresh_token = credentials["refresh_token"]
    @api_client
  end

  def google_api
    return @api unless !@api
    @api = google_api_client.discovered_api('fusiontables', 'v1')
  end
end
