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

version_data = CollectionSpace::UiVersion.call(client)
puts "Success getting version?: #{version_data.success?}"
puts "Instance UI profile: #{version_data.profile}"
puts "Instance UI version: #{version_data.version}"
puts "Combined profile/version: #{version_data.joined}"

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get("conditionchecks")
ap response.parsed if response.result.success?

# GET ALL PERSON RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all("personauthorities/urn:cspace:name(person)/items").each do |item|
  puts item
end
