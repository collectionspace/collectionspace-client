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

response = client.search(
  CollectionSpace::Search.new.from_hash(search_args),
  { sortBy: 'collectionspace_core:updatedAt DESC' }
)
ap response.parsed['abstract_common_list'] if response.result.success?

response = client.find(type: 'collectionobjects', value: 'QA TEST 001')
ap response.parsed['abstract_common_list'] if response.result.success?

response = client.find(
  type: 'placeauthorities',
  subtype: 'place',
  value: 'California',
  field: CollectionSpace::Service.get(type: 'placeauthorities')[:term]
)
ap response.parsed['abstract_common_list'] if response.result.success?
