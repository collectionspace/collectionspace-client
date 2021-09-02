# frozen_string_literal: true

require 'pry'

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
if response.result.success?
  response.parsed['abstract_common_list']['list_item'].map do |i|
    puts i['uri']
  end
end

puts 'Object and authority term searches have been moved to spec.'
puts 'See helpers_spec.rb examples describing find'
