# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace RefName
  class RefName
    attr_reader :domain, :type, :subtype, :identifier, :label

    def initialize(refname)
      @refname    = refname
      @domain     = nil
      @type       = nil
      @subtype    = nil
      @identifier = nil
      @label      = nil
      parse
    end

    def parse
      parts   = @refname.split(':')
      subpart = parts[4] =~ /^id/ ? :identifier : :subtype
      nilpart = parts[4] =~ /^id/ ? :subtype    : :identifier

      @domain = parts[2]
      @type   = parts[3]
      @label  = between_single_quotes(parts[4])
      instance_variable_set("@#{subpart}".to_sym, between_parens(parts[4]))
      instance_variable_set("@#{nilpart}".to_sym, nil)

      if parts.length > 5
        parts[6] = parts[6..parts.length].join(':') if parts.length > 7
        @identifier = between_parens(parts[6])
        @label      = between_single_quotes(parts[6])
      end

      self
    end

    # Convenience class method, so new instance of RefName does not have to be instantiated in order to parse
    #
    # As of v0.13.1, return_class is added and defaults to nil for backward compatibility
    # Eventually this default will be deprecated, and a parsed RefName object will be returned as the default.
    #   Any new code written using this method should set the return_class parameter to :refname_obj
    def self.parse(refname, return_class = nil)
      return_class == :refname_obj ? new(refname) : new(refname).to_h
    end

    def between_parens(part)
      regex_capture_first(/\((.*?)\)/, part)
    end

    def between_single_quotes(part)
      regex_capture_first(/'(.*)'/, part)
    end

    def regex_capture_first(regex, part)
      return nil unless part.match(regex)

      part.match(regex).captures[0]
    end

    # Returns a parsed RefName object as a hash.
    # As of v0.13.1, this is equivalent to calling RefName.parse('refnamevalue', :hash)
    # This was added to simplify the process of updating existing code that expects a hash when calling RefName.parse
    def to_h
      {
        domain: domain,
        type: type,
        subtype: subtype,
        identifier: identifier,
        label: label
      }
    end
  end
end
