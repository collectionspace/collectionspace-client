# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace search
  class Search
    attr_accessor :path, :namespace, :field, :expression

    DEFAULT_SORT = 'collectionspace_core:updatedAt DESC'

    def initialize(path: nil, namespace: nil, field: nil, expression: nil)
      @path       = path
      @namespace  = namespace
      @field      = field
      @expression = expression
    end

    def from_hash(query)
      query.each do |property, value|
        instance_variable_set("@#{property}", value)
      end
      self
    end
  end
end
