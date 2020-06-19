# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'uri'

# mixins required first
require 'collectionspace/client/helpers'

require 'collectionspace/client/client'
require 'collectionspace/client/configuration'
require 'collectionspace/client/request'
require 'collectionspace/client/response'
require 'collectionspace/client/search'
require 'collectionspace/client/service'
require 'collectionspace/client/version'

module CollectionSpace
  class ArgumentError < StandardError; end
  class PayloadError  < StandardError; end
  class RequestError  < StandardError; end
end
