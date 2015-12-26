require 'httparty'
require 'nokogiri'
require 'uri'

# mixins required first
require "collectionspace/client/helpers"

require "collectionspace/client/client"
require "collectionspace/client/configuration"
require "collectionspace/client/request"
require "collectionspace/client/response"
require "collectionspace/client/search"
require "collectionspace/client/version"

module CollectionSpace

  class ArgumentError < Exception ; end
  class PayloadError  < Exception ; end
  class RequestError  < Exception ; end

end