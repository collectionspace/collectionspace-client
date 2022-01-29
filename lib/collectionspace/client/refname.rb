# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace RefName
  class RefName
    def self.parse(refname)
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

      parsed
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
  end
end
