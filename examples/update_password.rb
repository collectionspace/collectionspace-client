# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'awesome_print'
require 'base64'
require 'collectionspace/client'

CS_CFG_URL  = ENV.fetch('CS_CFG_URL', 'https://core.dev.collectionspace.org/cspace-services')
CS_CFG_USER = ENV.fetch('CS_CFG_USER', 'admin@core.collectionspace.org')
CS_CFG_PASS = ENV.fetch('CS_CFG_PASS', 'Administrator')
CS_UPD_USER = ENV.fetch('CS_UPD_USER', 'admin@core.collectionspace.org')
CS_UPD_PASS = Base64.encode64(ENV.fetch('CS_UPD_PASS', 'Administrator')).chomp

client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: CS_CFG_URL,
    username: CS_CFG_USER,
    password: CS_CFG_PASS
  )
)

PAYLOAD = <<~XML
  <ns2:accounts_common xmlns:ns2="http://collectionspace.org/services/account">
      <userId>#{CS_UPD_USER}</userId>
      <password>#{CS_UPD_PASS}</password>
  </ns2:accounts_common>
XML

client.all('accounts').each do |item|
  next unless item['email'] == CS_UPD_USER

  ap client.put(item['uri'], PAYLOAD).parsed
end
