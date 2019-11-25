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
  type: 'groups_common',
  field: 'title',
  expression: "ILIKE '%DTS 001%'"
}

response = client.search(CollectionSpace::Search.new.from_hash(search_args))
ap response.parsed['abstract_common_list'] if response.result.success?
