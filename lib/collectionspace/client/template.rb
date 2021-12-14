# frozen_string_literal: true

module CollectionSpace
  module Template
    def self.list
      Dir.glob File.join(templates_path, '*.erb')
    end

    def self.process(template, data)
      t = ERB.new(read(template))
      r = t.result(binding).gsub(/\n+/, "\n")
      Nokogiri::XML.parse(r).to_xml
    end

    def self.read(file)
      File.read("#{templates_path}/#{file}.xml.erb")
    end

    def self.templates_path
      ENV.fetch(
        'COLLECTIONSPACE_CLIENT_TEMPLATES_PATH',
        File.join(File.dirname(File.expand_path(__FILE__)), 'templates')
      )
    end
  end
end
