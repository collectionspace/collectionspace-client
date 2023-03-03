# frozen_string_literal: true

require "strscan"

module CollectionSpace
  # CollectionSpace RefName
  #
  # There are four patterns we need to handle:
  #
  # - urn:cspace:domain:type:name(subtype)'label'                       : Top level authority/vocabulary
  # - urn:cspace:domain:type:name(subtype):item:name(identifier)'label' : Authority/vocabulary term
  # - urn:cspace:domain:type:id(identifier)'label'                      : Collectionobject
  # - urn:cspace:domain:type:id(identifier)                             : Procedures, relations, blobs
  class RefName
    attr_reader :domain, :type, :subtype, :identifier, :label

    def initialize(refname)
      @refname = refname
      @domain = nil
      @type = nil
      @subtype = nil
      @identifier = nil
      @label = nil
      parse
    end

    def parse
      scanner = StringScanner.new(@refname)
      scanner.skip("urn:cspace:")
      @domain = to_next_colon(scanner)
      @type = to_next_colon(scanner)

      case next_segment(scanner)
      when "name"
        set_subtype(scanner)
      when "id"
        set_identifier(scanner)
      end

      self
    end

    # Convenience class method, so new instance of RefName does not have to be instantiated in order to parse
    #
    # As of v0.13.1, return_class is added and defaults to nil for backward compatibility
    # Eventually this default will be deprecated, and a parsed RefName object will be returned as the default.
    #   Any new code written using this method should set the return_class parameter to :refname_obj
    def self.parse(refname, return_class = nil)
      (return_class == :refname_obj) ? new(refname) : new(refname).to_h
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

    private

    def next_segment(scanner)
      segment = scanner.check_until(/\(/)
      return nil unless segment

      segment.delete_suffix("(")
    end

    def set_identifier(scanner)
      scanner.skip("id(")
      @identifier = to_end_paren(scanner)
      return if scanner.eos?

      set_label(scanner)
    end

    def set_label(scanner)
      scanner.skip("'")
      @label = scanner.rest.delete_suffix("'")
    end

    def set_subtype(scanner)
      scanner.skip("name(")
      @subtype = to_end_paren(scanner)

      case next_segment(scanner)
      when nil
        set_label(scanner)
      when ":item:name"
        set_term_identifier(scanner)
      end
    end

    def set_term_identifier(scanner)
      scanner.skip(":item:name(")
      @identifier = to_end_paren(scanner)
      scanner.skip("'")
      set_label(scanner)
    end

    def to_end_paren(scanner)
      scanner.scan_until(/\)/).delete_suffix(")")
    end

    def to_next_colon(scanner)
      scanner.scan_until(/:/).delete_suffix(":")
    end
  end
end
