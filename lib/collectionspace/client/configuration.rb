# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace configuration
  class Configuration
    DEFAULTS = {
      base_uri: nil,
      username: nil,
      password: nil,
      page_size: 25,
      include_deleted: false,
      throttle: 0,
      timeout: 60,
      verbose: false,
      verify_ssl: true
    }.freeze

    attr_accessor :base_uri, :username, :password, :page_size, :include_deleted,
      :throttle, :timeout, :verbose, :verify_ssl

    def initialize(settings = {})
      DEFAULTS.merge(settings).each do |property, value|
        next unless DEFAULTS.key?(property)

        send(:"#{property}=", value)
      end
    end
  end
end
