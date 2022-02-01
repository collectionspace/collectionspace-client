# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::RefName do
  let(:result) { CollectionSpace::RefName.parse(refname, :refname_obj) }
  let(:result_as_hash) { CollectionSpace::RefName.parse(refname) }
  let(:refname) do
    "urn:cspace:core.collectionspace.org:personauthorities:name(person):item:name(1234561562130996026)'123456'"
  end

  describe '.parse' do
    context 'with :refname_obj passed in as return_class' do
      it 'returns a parsed RefName object' do
        expect(result).to be_a(CollectionSpace::RefName)
      end
    end

    context 'with collectionobject refname' do
      let(:refname) do
        "urn:cspace:core.collectionspace.org:collectionobjects:id(09f531bd-4f12-4c36-9f92)'Loaned object 1'"
      end
      
      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'collectionobjects',
          subtype: nil,
          identifier: '09f531bd-4f12-4c36-9f92',
          label: 'Loaned object 1'
        })
      end
    end

    context 'with procedure refname' do
      let(:refname) do
        'urn:cspace:core.collectionspace.org:acquisitions:id(5043d8cc-9437-4bc7-92d1)'
      end

      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'acquisitions',
          subtype: nil,
          identifier: '5043d8cc-9437-4bc7-92d1',
          label: nil
        })
      end
    end

    context 'with relation refname' do
      let(:refname) do
        'urn:cspace:core.collectionspace.org:relations:id(da044bc2-9fbf-474d-803a)'
      end

      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'relations',
          subtype: nil,
          identifier: 'da044bc2-9fbf-474d-803a',
          label: nil
        })
      end
    end

    context 'with top level authority refname' do
      let(:refname) do
        "urn:cspace:core.collectionspace.org:personauthorities:name(person)'Local Persons'"
      end

      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'personauthorities',
          subtype: 'person',
          identifier: nil,
          label: 'Local Persons'
        })
      end
    end

    context 'with authority term refname' do
      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'personauthorities',
          subtype: 'person',
          identifier: '1234561562130996026',
          label: '123456'
        })
      end
    end

    context 'with refname containing colon' do
      let(:refname) do
        "urn:cspace:core.collectionspace.org:locationauthorities:name(location):item:name(AR1U1Shelf14078111602)'A:R1:U1:Shelf 1'"
      end

      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'locationauthorities',
          subtype: 'location',
          identifier: 'AR1U1Shelf14078111602',
          label: 'A:R1:U1:Shelf 1'
        })
      end
    end

    context 'with refname containing parentheses' do
      let(:refname) do
        "urn:cspace:core.collectionspace.org:conceptauthorities:name(concept):item:name(JMAlexanderCompanyAtlantaGa1028284796)'J.M. Alexander & Company (Atlanta, Ga.)'"
      end

      it 'parses as expected' do
        expect(result_as_hash).to eq({
          domain: 'core.collectionspace.org',
          type: 'conceptauthorities',
          subtype: 'concept',
          identifier: 'JMAlexanderCompanyAtlantaGa1028284796',
          label: 'J.M. Alexander & Company (Atlanta, Ga.)'
        })
      end
    end
  end

  describe '#to_h' do
    it 'returns expected hash' do
      expect(result.to_h).to eq(result_as_hash)
    end
  end
end
