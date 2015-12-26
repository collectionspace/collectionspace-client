module CollectionSpace

  class Configuration

    def defaults
      {
        base_uri: "http://demo.collectionspace.org:8180/cspace-services",
        username: "admin@core.collectionspace.org",
        password: "Administrator",
        page_size: 50,
        include_deleted: false,
        throttle: 0,
        verify_ssl: true,
      }
    end

    def initialize(settings = {})
      settings = defaults.merge(settings)
      settings.each do |property, value|
        next unless defaults.keys.include? property
        instance_variable_set("@#{property}", value)
        self.class.send(:attr_accessor, property)
      end
    end

  end

end