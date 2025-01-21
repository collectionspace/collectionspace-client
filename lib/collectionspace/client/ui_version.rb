# frozen_string_literal: true

require "strscan"
require "net/http"
require "uri"

module CollectionSpace
  # CollectionSpace request
  class UiVersion
    Data = Struct.new(:status, :message, :profile, :version,
      keyword_init: true) do
      def success? = status == :success

      def failure? = !success?

      def joined
        return if failure?

        [profile, version].compact.join("_")
      end
    end

    class << self
      def call(...) = new(...).call
    end

    # @param client [CollectionSpace::Client]
    def initialize(client)
      @uri = client.config.base_uri
    end

    def call
      body = retrieve_response
      return body if body.respond_to?(:status) && body.status == :failure

      script = last_script_src(body)
      return script if script.respond_to?(:status) && script.status == :failure

      version = extract_version(script) if script
      return version if version.respond_to?(:status) &&
        version.status == :failure

      profile = extract_profile(script) if version
      return profile if profile.respond_to?(:status) &&
        profile.status == :failure

      Data.new(status: :success,
        profile: profile.downcase.tr(" ", "-"),
        version: version.tr(".", "-"))
    end

    private

    attr_reader :uri

    def retrieve_response
      unless response.is_a?(Net::HTTPSuccess)
        return Data.new(status: :failure, message: response.message)
      end

      response.body
    end

    def response
      @response ||= fetch(base_uri)
    rescue => err
      err
    end

    def base_uri = URI(uri.sub(/\/cspace-services\/?/, ""))

    def fetch(uri, limit = 10)
      uri = URI(uri) unless uri.is_a?(URI)

      # You should choose a better exception.
      raise ArgumentError, "too many HTTP redirects" if limit == 0

      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess
        response
      when Net::HTTPRedirection
        location = response["location"]
        new_loc = "#{base_uri}#{location}"
        fetch(new_loc, limit - 1)
      else
        response.value
      end
    end

    def last_script_src(str)
      scripts = []
      scanner = StringScanner.new(str)
      script_begin = Regexp.new("<script src=\"")
      script_end_str = '"></script>'
      script_end = Regexp.new(script_end_str)

      while scanner.exist?(script_begin)
        scanner.scan_until(script_begin)
        scripts << scanner.scan_until(script_end)
          .delete_suffix(script_end_str)
      end

      if scripts.empty?
        return Data.new(status: :failure,
          message: "No CollectionSpace UI plugin script sources " \
            "detected for #{base_uri}")
      end

      scripts.last
    end

    def extract_version(src)
      case src
      when /^\/cspace-ui/
        extract_from_cspace_ui_src(src)
      when /cspace-ui-plugin-profile-.*@\d.*cspaceUIPluginProfile.*\.min\.js/
        get_specific_delivered_version(src)
      when /^https:\/\/cdn\.jsdelivr\.net\/npm.*@latest/
        get_latest_npm_version(src)
      else
        Data.new(status: :failure, message: "Unhandled src type: #{src}")
      end
    end

    def extract_from_cspace_ui_src(src)
      src.match(/@(.*)\.min\.js/)
        .captures
        .first
    rescue
      Value.new(status: :failure, message: "Cannot extract version from #{src}")
    end

    def get_specific_delivered_version(src)
      src.match(/cspace-ui-plugin-profile-.*@(\d[^\/]+)\//)
        .captures
        .first
    end

    def get_latest_npm_version(src)
      package = src.match(/npm\/(.*)@latest/)
        .captures.first
      uri = URI("https://data.jsdelivr.com/v1/packages/npm/#{package}")
      response = fetch(uri)
      unless response.is_a?(Net::HTTPSuccess)
        return Data.new(status: :failure,
          message: "ERROR: Cannot retrieve latest version " \
             "number for #{package} from jsdelivr: " \
             "#{response.message}")
      end

      data = JSON.parse(response.body)
      value = data.dig("tags", "latest")
      unless value
        return Data.new(status: :failure,
          message: "Could not extract latest version from #{uri}")
      end

      value
    end

    def extract_profile(src)
      return "core" if src.match?(/^\/cspace-ui\/cspaceUI@/)

      src.match(/UIPluginProfile([^@]+)(?:@|\.min\.js)/)
        .captures.first
    end
  end
end
