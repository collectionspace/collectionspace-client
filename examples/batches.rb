# frozen_string_literal: true

# Install batches (aka data updates)
# Based on:
# https://github.com/collectionspace/Tools/blob/master/scripts/install_batch_records.sh
# https://github.com/collectionspace/Tools/blob/master/scripts/create-batch-records.sh

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"
require "pry"

STANDARD_TENANTS = [
  :anthro,
  :bonsai,
  :botgarden,
  :core,
  :fcart,
  :herbarium,
  :lhmc,
  :materials,
  :publicart
]

STANDARD_BATCHES = CollectionSpace::Batch.all

STANDARD_TENANTS.each do |tenant|
  client = CollectionSpace::Client.new(
    CollectionSpace::Configuration.new(
      base_uri: "https://#{tenant}.dev.collectionspace.org/cspace-services",
      username: "admin@#{tenant}.collectionspace.org",
      password: "Administrator"
    )
  )
  base = client.config.base_uri
    .delete_suffix("/cspace-services")
    .delete_prefix("https://")
  merge_doctypes = client.authority_doctypes

  STANDARD_BATCHES.each do |batch|
    batch[:doctype] = merge_doctypes if batch[:name] == "Merge Authority Items"
    response = client.add_batch(batch)
    if response.result.success?
      puts "Added #{batch[:name]} to #{base}"
    else
      puts "FAILED TO ADD #{batch[:name]} to #{base}"
      puts response.inspect
    end
  end
end
