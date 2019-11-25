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

    def initialize(settings = {})
      settings = defaults.merge(settings)
      settings.each do |property, value|
        next unless defaults.key? property

        instance_variable_set("@#{property}", value)
        self.class.send(:attr_accessor, property)
      end
    end
  end
end
