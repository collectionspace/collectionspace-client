module CollectionSpace

  class Request
    include HTTParty
    attr_reader :config, :headers, :method, :path, :options

    def default_headers(method = :get)
      headers = {
        delete: {},
        get: {},
        post: {
          "Content-Type" => "application/xml",
          "Content-Length" => "nnnn",
        },
        put: {
          "Content-Type" => "application/xml",
          "Content-Length" => "nnnn",
        }
      }
      headers[method]
    end

    def initialize(config, method = "GET", path = "", options = {})
      @config  = config
      @method  = method.downcase.to_sym
      @path    = path

      @auth = {
        username: config.username,
        password: config.password,
      }

      @options = options
      @options[:basic_auth] = @auth
      @options[:headers]    = options[:headers] ? default_headers(@method).merge(options[:headers]) : default_headers(@method)
      @options[:verify]     = config.verify_ssl
      @options[:query]      = {} unless options.has_key? :query

      self.class.base_uri config.base_uri
      self.class.default_params wf_deleted: config.include_deleted, pgSz: config.page_size
    end

    def execute
      self.class.send method, "/#{path}", options
    end

  end

end
