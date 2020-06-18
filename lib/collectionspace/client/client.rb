# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace client
  class Client
    include Helpers
    attr_reader :config

    def initialize(config = Configuration.new)
      unless config.is_a? CollectionSpace::Configuration
        raise CollectionSpace::ArgumentError, 'Invalid configuration object'
      end

      @config = config
    end

    def get(path, options = {})
      request 'GET', path, options
    end

    def post(path, payload, options = {})
      check_payload(payload)
      request 'POST', path, { body: payload }.merge(options)
    end

    def put(path, payload)
      check_payload(payload)
      request 'PUT', path, body: payload
    end

    def delete(path)
      request 'DELETE', path
    end

    private

    def check_payload(payload)
      errors = Nokogiri::XML(payload).errors
      raise CollectionSpace::PayloadError, errors if errors.any?
    end

    def request(method, path, options = {})
      sleep config.throttle
      Response.new(Request.new(config, method, path, options).execute)
    end
  end
end
