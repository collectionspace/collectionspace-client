# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'awesome_print'
require 'collectionspace/client'

config = CollectionSpace::Configuration.new(
  base_uri: 'https://core.dev.collectionspace.org/cspace-services',
  username: 'admin@core.collectionspace.org',
  password: 'Administrator'
)

client = CollectionSpace::Client.new(config)

search_args = {
  path: 'groups',
  namespace: 'groups_common',
  field: 'title',
  expression: "ILIKE '%D%'"
}

puts 'Search: %D'
response = client.search(
  CollectionSpace::Search.new.from_hash(search_args),
  { sortBy: 'collectionspace_core:updatedAt DESC' }
)
response.parsed['abstract_common_list']['list_item'].map do |i|
  puts i['uri']
end if response.result.success?

puts "Search: QA TEST 001"
response = client.find(type: 'collectionobjects', value: 'QA TEST 001')
ap response.parsed['abstract_common_list'] if response.result.success?

[
  {type: 'placeauthorities', subtype: 'place', value: 'California'},
  {type: 'placeauthorities', subtype: 'place', value: 'Death Valley'},
  {type: 'placeauthorities', subtype: 'place', value: 'Hamilton!, Ohio'},
  {type: 'placeauthorities', subtype: 'place', value: '姫路城'},
  {type: 'placeauthorities', subtype: 'place', value: "No'Where"},
  {type: 'personauthorities', subtype: 'person', value: 'Morris, Perry(Pete)'},
  {type: 'personauthorities', subtype: 'person', value: 'Clark, H. Pol & Mary Gambo'},
  {type: 'orgauthorities', subtype: 'organization', value: "Smith's Appletree Garager"},
  {type: 'orgauthorities', subtype: 'organization', value: 'The "Grand" Canyon'},
].each do |term|
  puts "Search: #{term[:value]}"
  response = client.find(
    type: term[:type],
    subtype: term[:subtype],
    value: term[:value],
    field: CollectionSpace::Service.get(type: term[:type])[:term]
  )
  puts response.parsed['abstract_common_list']['list_item']['uri'] if response.result.success?
end
