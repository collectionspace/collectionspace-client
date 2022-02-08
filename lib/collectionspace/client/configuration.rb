# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace configuration
  class Configuration
    class << self
      def defaults
        {
          base_uri: nil,
          username: nil,
          password: nil,
          page_size: 25,
          include_deleted: false,
          throttle: 0,
          verify_ssl: true
        }
      end

      # The first time a Configuration instance is created, creates `attr_accessor` for each key
      #   in defaults
      # Then it undefines and redefines itself as a blank method.
      # The `undef` is required to avoid 'method redefined' warnings
      def set_attr_accessors
        defaults.keys.each{ |setting| send(:attr_accessor, setting) }
        undef :set_attr_accessors
        define_singleton_method(:set_attr_accessors){}
      end
    end

    def initialize(settings = {})
      settings = self.class.defaults.merge(settings)
      settings.each do |property, value|
        next unless self.class.defaults.key?(property)

        instance_variable_set("@#{property}", value)
      end

      self.class.set_attr_accessors
    end
  end
end
