# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace RefName
  class RefName
    # Convenience class method, so new instance of RefName does not have to be instantiated in order to parse
    #
    # As of v0.13.1, return_class is added and defaults to nil for backward compatibility
    # Eventually this default will be deprecated, and a parsed RefName object will be returned as the default.
    #   Any new code written using this method should set the return_class parameter to :refname_obj
    def self.parse(refname, return_class = nil)
      parts   = refname.split(':')
      subpart = parts[4] =~ /^id/ ? :identifier : :subtype
      nilpart = parts[4] =~ /^id/ ? :subtype    : :identifier

      parsed = {
        domain: parts[2],
        type: parts[3],
        subpart => between_parens(parts[4]),
        nilpart => nil
      }
      parsed[:label] = between_single_quotes(parts[4])

      if parts.length > 5
        parts[6] = parts[6..parts.length].join(':') if parts.length > 7
        parsed[:identifier] = between_parens(parts[6])
        parsed[:label] = between_single_quotes(parts[6])
      end

      return_class == :refname_obj ? new(parsed) : parsed
    end

    def self.between_parens(part)
      regex_capture_first(/\((.*?)\)/, part)
    end

    def self.between_single_quotes(part)
      regex_capture_first(/'(.*)'/, part)
    end

    def self.regex_capture_first(regex, part)
      return nil unless part.match(regex)

      part.match(regex).captures[0]
    end

    def initialize(parsed_hash)
      parsed_hash.each { |attr, val| instance_variable_set("@#{attr}".to_sym, val) }
    end

    attr_reader :domain, :type, :subtype, :identifier, :label

    # Returns a parsed RefName object as a hash.
    # As of v0.13.1, this is equivalent to calling RefName.parse('refnamevalue', :hash)
    # This was added to simplify the process of updating existing code that expects a hash when calling RefName.parse
    def to_h
      instance_variables.map { |var| [var.to_s.delete_prefix('@').to_sym, instance_variable_get(var)] }.to_h
    end
  end
end
