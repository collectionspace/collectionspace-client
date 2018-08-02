$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new
client.config.throttle = 1

# ap client.get('media/c453755d-3442-4516-9883').xml.to_xml

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

response = client.post('media', media, { query: { "blobUri" => media_url } })
puts response.status_code
if response.status_code == 201
  puts response.headers['location']
end
