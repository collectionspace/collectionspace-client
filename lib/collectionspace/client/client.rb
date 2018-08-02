module CollectionSpace

  class Client
    include DeepFind
    include Helpers
    attr_reader :config

    def initialize(config = Configuration.new)
      raise "Invalid configuration object" unless config.kind_of? CollectionSpace::Configuration
      @config = config
    end

    def get(path, options = {})
      request 'GET', path, options
    end

    # additional_options: { query: { foo: 'bar' } }
    def post(path, payload, additional_options = {})
      raise PayloadError.new, Nokogiri::XML(payload).errors if Nokogiri::XML(payload).errors.any?
      request 'POST', path, { body: payload }.merge(additional_options)
    end

    def put(path, payload)
      raise PayloadError.new, Nokogiri::XML(payload).errors if Nokogiri::XML(payload).errors.any?
      request 'PUT', path, { body: payload }
    end

    def delete(path)
      request 'DELETE', path
    end

    private

    def request(method, path, options = {})
      sleep config.throttle
      result = Request.new(config, method, path, options).execute
      Response.new result
    end

  end

end
