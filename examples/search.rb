$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new
client.config.throttle = 1

search_args = {
  path: "collectionobjects",
  type: "collectionobjects_common",
  field: 'titleGroupList/*1/title',
  expression: "ILIKE '%blue%'",
}

query = CollectionSpace::Search.new.from_hash search_args
ap client.search(query).parsed
