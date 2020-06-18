# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace request
  class Request
    include HTTParty
    attr_reader :config, :headers, :method, :path, :options

    def default_headers(method = :get)
      headers = {
        delete: {},
        get: {},
        post: {
          'Content-Type' => 'application/xml',
          'Content-Length' => 'nnnn'
        },
        put: {
          'Content-Type' => 'application/xml',
          'Content-Length' => 'nnnn'
        }
      }
      headers[method]
    end

    def initialize(config, method = 'GET', path = '', options = {})
      @config = config
      @method = method.downcase.to_sym
      @path   = path.gsub(%r{^/}, '')

      @auth = {
        username: config.username,
        password: config.password
      }

      headers = default_headers(@method).merge(options.fetch(:headers, {}))
      @options = options
      @options[:basic_auth] = @auth
      @options[:headers]    = headers
      @options[:verify]     = config.verify_ssl
      @options[:query]      = options.fetch(:query, {})

      self.class.base_uri config.base_uri
      self.class.default_params(
        wf_deleted: config.include_deleted,
        pgSz: config.page_size
      )
    end

    def execute
      self.class.send method, "/#{path}", options
    end
  end
end
