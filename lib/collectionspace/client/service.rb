# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace service
  class Service
    TERM_SUFFIX = 'TermGroupList/0/termDisplayName'
    def self.get(type:, subtype: '')
      {
        'acquisitions' => {
          identifier: 'acquisitionReferenceNumber',
          ns_prefix: 'acquisitions',
          path: 'acquisitions',
          term: nil
        },
        'citationauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'citations',
          path: "citationauthorities/urn:cspace:name(#{subtype})/items",
          term: "citation#{TERM_SUFFIX}"
        },
        'claims' => {
          identifier: 'claimNumber',
          ns_prefix: 'claims',
          path: 'claims',
          term: nil
        },
        'collectionobjects' => {
          identifier: 'objectNumber',
          ns_prefix: 'collectionobjects',
          path: 'collectionobjects',
          term: nil
        },
        'conceptauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'concepts',
          path: "conceptauthorities/urn:cspace:name(#{subtype})/items",
          term: "concept#{TERM_SUFFIX}"
        },
        'conditionchecks' => {
          identifier: 'conditionCheckRefNumber',
          ns_prefix: 'conditionchecks',
          path: 'conditionchecks',
          term: nil
        },
        'conservation' => {
          identifier: 'conservationNumber',
          ns_prefix: 'conservation',
          path: 'conservation',
          term: nil
        },
        'exhibitions' => {
          identifier: 'exhibitionNumber',
          ns_prefix: 'exhibitions',
          path: 'exhibitions',
          term: nil
        },
        'groups' => {
          identifier: 'title',
          ns_prefix: 'groups',
          path: 'groups',
          term: nil
        },
        'intakes' => {
          identifier: 'entryNumber',
          ns_prefix: 'intakes',
          path: 'intakes',
          term: nil
        },
        'loansin' => {
          identifier: 'loanInNumber',
          ns_prefix: 'loansin',
          path: 'loansin',
          term: nil
        },
        'loansout' => {
          identifier: 'loanOutNumber',
          ns_prefix: 'loansout',
          path: 'loansout',
          term: nil
        },
        'locationauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'locations',
          path: "locationauthorities/urn:cspace:name(#{subtype})/items",
          term: "loc#{TERM_SUFFIX}"
        },
        'materialauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'materials',
          path: "materialauthorities/urn:cspace:name(#{subtype})/items",
          term: "material#{TERM_SUFFIX}"
        },
        'media' => {
          identifier: 'identificationNumber',
          ns_prefix: 'media',
          path: 'media',
          term: nil
        },
        'movements' => {
          identifier: 'movementReferenceNumber',
          ns_prefix: 'movements',
          path: 'movements',
          term: nil
        },
        'objectexit' => {
          identifier: 'exitNumber',
          ns_prefix: 'objectexit',
          path: 'objectexit',
          term: nil
        },
        'orgauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'organizations',
          path: "orgauthorities/urn:cspace:name(#{subtype})/items",
          term: "org#{TERM_SUFFIX}"
        },
        'osteology' => {
          identifier: 'InventoryID',
          ns_prefix: 'osteology',
          path: 'osteology',
          term: nil
        },
        'personauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'persons',
          path: "personauthorities/urn:cspace:name(#{subtype})/items",
          term: "person#{TERM_SUFFIX}"
        },
        'placeauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'places',
          path: "placeauthorities/urn:cspace:name(#{subtype})/items",
          term: "place#{TERM_SUFFIX}"
        },
        'relations' => {
          identifier: 'csid',
          ns_prefix: 'relations',
          path: 'relations',
          term: nil
        },
        'taxonomyauthority' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'taxon',
          path: "taxonomyauthority/urn:cspace:name(#{subtype})/items",
          term: "place#{TERM_SUFFIX}"
        },
        'uoc' => {
          identifier: 'referenceNumber',
          ns_prefix: 'uoc',
          path: 'uoc',
          term: nil
        },
        'valuationcontrols' => {
          identifier: 'valuationcontrolRefNumber',
          ns_prefix: 'valuationcontrols',
          path: 'valuationcontrols',
          term: nil
        },
        'vocabularies' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'vocabularyitems',
          path: "vocabularies/urn:cspace:name(#{subtype})/items",
          term: 'displayName'
        },
        'workauthorities' => {
          identifier: 'shortIdentifier',
          ns_prefix: 'works',
          path: "workauthorities/urn:cspace:name(#{subtype})/items",
          term: "work#{TERM_SUFFIX}"
        }
      }.fetch(type)
    end
  end
end
