require 'yaml'
require 'google/api_client'
require 'pry'

config_file = File.expand_path('~/.google-api.yaml')
if File.exist?(config_file)
  config = open(config_file, 'r') { |file| YAML.load(file.read) }
else
  p "ERROR: need to generate authorization file"
  # be ./bin/google-api oauth-2-login --client-id 104152475607.apps.googleusercontent.com --client-secret aaTGo5CozgbMVBxDFvzl6uqz --scope https://www.googleapis.com/auth/fusiontables.readonly -v
end

# client = Google::APIClient.new(:authorization => :oauth_2)
client = Google::APIClient.new
client.authorization.scope = config["scope"]
client.authorization.client_id = config["client_id"]
client.authorization.client_secret = config["client_secret"]
client.authorization.access_token = config["access_token"]
client.authorization.refresh_token = config["refresh_token"]

request_body = ''
headers = []
headers << ['Content-Type', 'application/json']

api = client.discovered_api('fusiontables', 'v1')

result = client.execute(
  :api_method => api.to_h['fusiontables.table.list'],
  :merged_body => request_body,
  :headers => headers
)
puts result.response.body

result_json = JSON.parse(result.response.body)
table_id = result_json["items"][3]["tableId"]
parameters = {"sql" => "select * from #{table_id}"};
puts "doing sqlGet...#{parameters}"
result = client.execute(
  :api_method => api.to_h['fusiontables.query.sqlGet'],
  :parameters => parameters, 
  :merged_body => request_body,
  :headers => headers
)

puts result.response.body
filename = 'ft-response.json'
puts "Writing result to #{filename}"
file = open(filename,'w')
file.write(result.response.body)
file.close
