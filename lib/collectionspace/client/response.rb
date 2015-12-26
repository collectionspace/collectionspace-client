module CollectionSpace

  class Response
    attr_reader :result, :parsed, :body, :headers, :status, :status_code, :xml

    def initialize(result)
      # throw error
      @result      = result
      @parsed      = result.parsed_response
      @body        = result.body
      @headers     = result.headers
      @status      = result.response
      @status_code = result.code.to_i

      @xml = (@status_code.to_s =~ /^2/ and @body =~ /<?xml/) ? Nokogiri::XML(@body) : nil
    end

  end

end