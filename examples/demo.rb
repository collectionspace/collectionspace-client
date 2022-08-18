# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: "https://core.dev.collectionspace.org/cspace-services",
    username: "admin@core.collectionspace.org",
    password: "Administrator"
  )
)

# GET REQUEST FOR CONDITIONCHECK RECORDS AND PRINT THE PARSED RESPONSE AND XML
response = client.get("conditionchecks")
ap response.parsed if response.result.success?

# GET ALL PERSON RECORDS AND PROCESS PER PAGE (INSTEAD OF WAITING FOR ALL)
client.all("personauthorities/urn:cspace:name(person)/items").each do |item|
  puts item
end
