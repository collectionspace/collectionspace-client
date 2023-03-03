# frozen_string_literal: true

require "httparty"
require "nokogiri"
require "uri"

# mixins required first
require "collectionspace/client/helpers"
require "collectionspace/client/template"

require "collectionspace/client/batch"
require "collectionspace/client/client"
require "collectionspace/client/configuration"
require "collectionspace/client/refname"
require "collectionspace/client/report"
require "collectionspace/client/request"
require "collectionspace/client/response"
require "collectionspace/client/search"
require "collectionspace/client/service"
require "collectionspace/client/version"

module CollectionSpace
  class ArgumentError < StandardError; end

  class DuplicateIdFound < StandardError; end

  class NotFoundError < StandardError; end

  class PayloadError < StandardError; end

  class RequestError < StandardError; end
end
