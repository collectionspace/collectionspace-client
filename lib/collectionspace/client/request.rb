# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace request
  class Request
    include HTTParty

    attr_reader :config, :headers, :method, :path, :options

    DEFAULT_HEADERS = {"Content-Type" => "application/xml"}.freeze

    def initialize(config, method = "GET", path = "", options = {})
      @config = config
      @method = method.downcase.to_sym
      @path = path.gsub(%r{^/+}, "")

      @options = options.dup
      @options[:basic_auth] = {username: config.username, password: config.password}

      @options[:headers] = DEFAULT_HEADERS.merge(@options.fetch(:headers, {}))
      @options[:headers]["User-Agent"] = "#{Client::NAME}/#{Client::VERSION}"

      @options[:query] = @options.fetch(:query, {})
      @options[:timeout] = config.timeout
      @options[:verify] = config.verify_ssl

      self.class.base_uri config.base_uri
      self.class.debug_output $stdout if config.verbose
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
