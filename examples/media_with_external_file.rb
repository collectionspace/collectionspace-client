# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: "https://core.dev.collectionspace.org/cspace-services",
    username: "admin@core.collectionspace.org",
    password: "Administrator"
  )
)
client.config.throttle = 1

media_url = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"
media = <<-XML
  <?xml version="1.0" encoding="UTF-8"?>
  <document name="media">
    <ns2:media_common xmlns:ns2="http://collectionspace.org/services/media" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <title>GOOGLE</title>
      <identificationNumber>GOOGLE-1</identificationNumber>
    </ns2:media_common>
  </document>
XML

response = client.post("media", media, query: {"blobUri" => media_url})
puts response.result.headers["location"] if response.result.success?
