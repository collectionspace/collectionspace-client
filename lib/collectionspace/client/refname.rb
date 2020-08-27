# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace RefName
  class RefName
    def self.parse(refname)
      parts = refname.split(':')
      parsed = {
        domain: parts[2],
        type: parts[3],
        subtype: parts[4].match(/\((.*)\)/).captures[0]
      }
      if parts.length > 5
        parts[6] = parts[6..parts.length].join(':') if parts.length > 7
        parsed[:identifier] = parts[6].match(/\((.*?)\)/).captures[0]
        parsed[:label] = parts[6].match(/'(.*)'/).captures[0]
      end
      parsed
    end
  end
end
