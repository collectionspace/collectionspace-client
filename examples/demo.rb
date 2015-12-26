$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new
client.config.throttle = 1

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get('conditionchecks')
if response.status_code == 200
  ap response.parsed
  ap response.xml
end

# GET ALL ACQUISITIONS AND PRINT TO CONSOLE
acquisitions = client.all('acquisitions')
ap acquisitions

# GET ALL INTAKE RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all('intakes') do |item|
  uri    = item["uri"]
  intake = client.get uri
  ap intake.parsed
end
