# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Service do
  it 'can retrieve service details' do
    service = CollectionSpace::Service.get(type: 'collectionobjects')
    expect(service[:identifier]).to eq 'objectNumber'
    expect(service[:path]).to eq 'collectionobjects'
    expect(service[:term]).to be_nil

    service = CollectionSpace::Service.get(type: 'personauthorities', subtype: 'person')
    expect(service[:identifier]).to eq 'shortIdentifier'
    expect(service[:path]).to eq 'personauthorities/urn:cspace:name(person)/items'
    expect(service[:term]).to eq 'personTermGroupList/0/termDisplayName'

    service = CollectionSpace::Service.get(type: 'vocabularies', subtype: 'languages')
    expect(service[:identifier]).to eq 'shortIdentifier'
    expect(service[:path]).to eq 'vocabularies/urn:cspace:name(languages)/items'
    expect(service[:term]).to eq 'displayName'
  end
end
