$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new
client.config.throttle = 1

client.all('vocabularies').each do |item|
  uri = item["uri"]
  puts "Checking vocabulary: #{uri}"
  if client.count("#{uri}/items") == 0
    puts "Purging empty vocabulary:\t#{item['displayName']} (#{item['csid']})"
    # YOU WOULD UNCOMMENT THIS TO ACTUALLY PERFORM THE PURGE ...
    # client.delete uri
  end
end