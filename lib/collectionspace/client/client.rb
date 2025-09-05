# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace client
  class Client
    include Helpers
    attr_reader :config

    def initialize(config = Configuration.new)
      unless config.is_a? CollectionSpace::Configuration
        raise CollectionSpace::ArgumentError, "Invalid configuration object"
      end

      @config = config
    end

    # User is required to be authenticated in order to access accounts
    #   endpoint. We cannot distinguish between unknown user and known
    #   user with bad password because CollectionSpace returns a 401
    #   error regardless of reason for
    #   non-authentication/authorization
    def can_authenticate?
      return false unless login_credentials_provided?

      response = get("accounts/0/accountperms")
      response.result.success? &&
        response.parsed.respond_to?(:dig) &&
        response.parsed.dig("account_permission", "account",
          "userId") == config.username
    end

    def get(path, options = {})
      request "GET", path, options
    end

    def post(path, payload, options = {})
      check_payload(payload)
      request "POST", path, {body: payload}.merge(options)
    end

    def post_file(file, options = {})
      file = File.expand_path(file)
      raise ArgumentError, "cannot find file #{file}" unless File.exist? file

      request "POST", "blobs", {
        body: {
          file: File.open(file)
        }
      }.merge(options)
    end

    def put(path, payload = nil, options = {})
      if payload
        check_payload(payload)
        request "PUT", path, {body: payload}.merge(options)
      else
        request "PUT", path, options
      end
    end

    def delete(path)
      request "DELETE", path
    end

    def version
      Struct.new(:api, :client, :ui, keyword_init: true)
        .new(
          api: get_api_version,
          client: VERSION,
          ui: CollectionSpace::UiVersion.call(self)
        )
    end

    private

    def login_credentials_provided?
      config.username && config.password
    end

    def check_payload(payload)
      errors = Nokogiri::XML(payload).errors
      raise CollectionSpace::PayloadError, errors if errors.any?
    end

    def request(method, path, options = {})
      sleep config.throttle
      Response.new(Request.new(config, method, path, options).execute)
    end

    def get_api_version
      response = get("systeminfo")
      unless response.result.success?
        return CollectionSpace::ApiVersion.new(
          status: :failure, message: response.result.body
        )
      end

      version_info = response.parsed.dig("system_info_common", "version")
      CollectionSpace::ApiVersion.new(
        status: :success,
        major: version_info["major"],
        minor: version_info["minor"],
        patch: version_info["patch"],
        build: version_info["build"]
      )
    end
  end
end
