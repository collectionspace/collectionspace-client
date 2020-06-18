# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'collectionspace/client'

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: 'https://core.dev.collectionspace.org/cspace-services',
    username: 'admin@core.collectionspace.org',
    password: 'Administrator'
  )
)
client.config.throttle = 1

client.all('vocabularies').each do |item|
  uri = item['uri']
  puts "Checking vocabulary: #{uri}"
  next unless client.count("#{uri}/items").zero?

  puts "Purging empty vocabulary:\t#{item['displayName']} (#{item['csid']})"
  client.delete uri
end
