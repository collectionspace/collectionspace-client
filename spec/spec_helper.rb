$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'collectionspace/client'
require 'vcr'
require 'webmock/rspec'

# GLOBAL VALUES FOR SPECS
DEFAULT_BASE_URI = "http://demo.collectionspace.org:8180/cspace-services"
CUSTOM_BASE_URI  = "https://cspace.lyrasis.org/cspace-services"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
end