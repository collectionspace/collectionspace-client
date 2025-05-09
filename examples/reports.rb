# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "collectionspace/client"

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: "https://core.dev.collectionspace.org/cspace-services",
    username: "admin@core.collectionspace.org",
    password: "Administrator"
  )
)

report_xml = File.join("spec", "fixtures", "files", "Exhibition_List_Basic.xml")

response = client.add_report(report_xml)
if response.result.success?
  puts "Report added/updated"
else
  puts "Report addition/update failed"
  puts response.inspect
end
