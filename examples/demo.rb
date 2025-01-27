# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"

config = CollectionSpace::Configuration.new(
  base_uri: "https://core.collectionspace.org/cspace-services",
  username: "admin@core.collectionspace.org",
  password: "Administrator"
)
client = CollectionSpace::Client.new(config)

version_data = client.version
puts "Success getting UI version?: #{version_data.ui.success?}"
puts "Instance UI profile: #{version_data.ui.profile}"
puts "Instance UI version: #{version_data.ui.version}"
puts "Combined UI profile/version: #{version_data.ui.joined}"
puts ""
puts "Success getting API version?: #{version_data.api.success?}"
puts "API major version number: #{version_data.api.major}"
puts "API display version: #{version_data.api.joined}"
puts ""
puts "Client version: #{version_data.client}"

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get("conditionchecks")
ap response.parsed if response.result.success?

# GET ALL PERSON RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all("personauthorities/urn:cspace:name(person)/items").each do |item|
  puts item
end

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get("conditionchecks")
ap response.parsed if response.result.success?

# GET ALL PERSON RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all("personauthorities/urn:cspace:name(person)/items").each do |item|
  puts item
end
