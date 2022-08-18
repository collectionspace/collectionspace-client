# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace response
  class Response
    attr_reader :result, :parsed, :status_code, :xml

    def initialize(result)
      @result = result
      @parsed = result.parsed_response
      @status_code = result.code.to_i
      body = result.body
      @xml = @result.success? && body =~ /<?xml/ ? Nokogiri::XML(body) : nil
    end

    def find(list_type, item_type, property, value)
      total = parsed[list_type]["totalItems"].to_i
      return unless total.positive?

      list = parsed[list_type][item_type]
      list = [list] if total == 1 # wrap if single item
      list.find { |i| i[property] == value }
    end
  end
end
