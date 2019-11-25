$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'awesome_print'
require 'collectionspace/client'

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: 'https://core.dev.collectionspace.org/cspace-services',
    username: 'admin@core.collectionspace.org',
    password: 'Administrator'
  )
)
client.config.throttle = 1

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get('conditionchecks')
ap response.parsed if response.result.success?

# GET ALL INTAKE RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all('personauthorities').each do |item|
  i = client.get item['uri']
  ap i.parsed
end
