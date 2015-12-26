module CollectionSpace

  class Search
    attr_accessor :path, :type, :field, :expression

    def initialize(path: nil, type: nil, field: nil, expression: nil)
      @path, @type, @field, @expression = path, type, field, expression
    end

    def from_hash(query)
      query.each do |property, value|
        instance_variable_set("@#{property}", value)
      end
      self
    end

  end

end