# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace configuration
  class Configuration
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

    attr_accessor :foo
    def initialize(settings = {})
      settings = defaults.merge(settings)
      settings.each do |property, value|
        next unless defaults.key?(property)

        instance_variable_set("@#{property}", value)
        #self.class.send(:attr_accessor, property)
      end

      attributes = defaults.keys
      set_class_attrs(attributes) unless class_attrs_exist?(attributes)
    end
    
    private

    def class_attrs_exist?(settings)
      settings.all?{ |setting| methods.any?(setting) }
    end

    def set_class_attr(setting)
      return if [setting, "#{setting}=".to_sym].all?{ |meth| methods.any?(meth) }

      self.class.send(:attr_accessor, setting)
    end
    
    def set_class_attrs(settings)
      settings.each{ |setting| set_class_attr(setting) }
    end
  end
end
