# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace response
  class Response
    attr_reader :result, :parsed, :status_code, :xml

    def initialize(result)
      @result      = result
      @parsed      = result.parsed_response
      @status_code = result.code.to_i
      body = result.body
      @xml = @result.success? && body =~ /<?xml/ ? Nokogiri::XML(body) : nil
    end
  end
end
