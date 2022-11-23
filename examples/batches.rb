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

def standard_batches(client)
  [
    {
      name: "Update Current Location",
      notes: "Recompute the current location of Object records, based on the " \
        "related Location/Movement/Inventory records. Runs on a single record " \
        "or all records.",
      doctype: %w[CollectionObject],
      supports_single_doc: "true",
      supports_doc_list: "false",
      supports_group: "false",
      supports_no_context: "true",
      creates_new_focus: "false",
      classname:
      "org.collectionspace.services.batch.nuxeo.UpdateObjectLocationBatchJob"
    },
    {
      name: "Update Inventory Status",
      notes: "Set the inventory status of selected Object records. Runs on a " \
        "record list only.",
      doctype: %w[CollectionObject],
      supports_single_doc: "false",
      supports_doc_list: "true",
      supports_group: "false",
      supports_no_context: "false",
      creates_new_focus: "false",
      classname:
      "org.collectionspace.services.batch.nuxeo.UpdateInventoryStatusBatchJob"
    },
    {
      name: "Merge Authority Items",
      notes: "Merge an authority item into a target, and update all " \
        "referencing records. Runs on a single record only.",
      doctype: client.authority_doctypes,
      supports_single_doc: "true",
      supports_doc_list: "false",
      supports_group: "false",
      supports_no_context: "false",
      creates_new_focus: "false",
      classname:
      "org.collectionspace.services.batch.nuxeo.MergeAuthorityItemsBatchJob"
    }
  ]
end

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

  standard_batches(client).each do |batch|
    response = client.add_batch(batch)
    if response.result.success?
      puts "Added #{batch[:name]} to #{base}"
    else
      puts "FAILED TO ADD #{batch[:name]} to #{base}"
      puts response.inspect
    end
  end
end
