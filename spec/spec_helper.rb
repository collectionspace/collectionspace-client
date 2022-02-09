# frozen_string_literal: true

require 'simplecov'
SimpleCov.start{ enable_coverage :branch }

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'collectionspace/client'
require 'pry'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :once }
end

def default_client
  CollectionSpace::Client.new(
    CollectionSpace::Configuration.new(
      base_uri: 'https://core.dev.collectionspace.org/cspace-services',
      username: 'admin@core.collectionspace.org',
      password: 'Administrator'
    )
  )
end

def fixture(file)
  File.read(File.join('spec', 'fixtures', 'files', file))
end

def request_with_total(path)
  response = client.get(path)
  total    = response.parsed['abstract_common_list']['totalItems'].to_i
  [response, total]
end
