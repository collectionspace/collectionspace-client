# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Helpers do
  let(:client) { CollectionSpace::Client.new }

  describe '#get_list_types' do
    let(:result) { client.get_list_types(type) }
    context 'with accounts' do
      let(:type) { 'accounts' }
      it 'can get accounts list type' do
        expect(result).to eq(
          %w[accounts_common_list account_list_item]
        )
      end
    end

    context 'with regular type' do
      let(:type) { 'media' }
      it 'can get regular list type' do
        expect(result).to eq(
          %w[abstract_common_list list_item]
        )
      end
    end

    context 'with relations' do
      let(:type) { 'relations' }
      it 'can get relations list type' do
        expect(result).to eq(
          %w[relations_common_list relation_list_item]
        )
      end
    end
  end

  describe '#domain' do
    let(:client) { CollectionSpace::Client.new(CollectionSpace::Configuration.new) }
    it 'can get the client domain' do
      refname = "urn:cspace:core.collectionspace.org:personauthorities:name(ulan_pa)\'ULAN Persons\'"
      body = %({ "abstract_common_list": { "list_item": { "refName": "#{refname}" } } })
      allow(client).to receive(:request).and_return CollectionSpace::Response.new(
        OpenStruct.new(
          code: '200',
          body: body,
          parsed_response: JSON.parse(body),
          success?: true
        )
      )
      expect(client.domain).to eq('core.collectionspace.org')
    end
  end

  describe '#find' do
    let(:client) { default_client }
    let(:response) { client.find(args) }
    let(:result) { response.parsed['abstract_common_list']['list_item']['uri'] }

    context 'with object' do
      let(:args) { { type: 'collectionobjects', value: 'QA TEST 001' } }
      it 'finds as expected' do
        expect(result).to eq('/collectionobjects/56c04f5f-32b9-4f1d-8a4b')
      end
    end

    context 'with authority term' do
      it 'finds as expected' do
        args = [
          { type: 'placeauthorities', subtype: 'place', value: 'California' },
          { type: 'placeauthorities', subtype: 'place', value: 'Death Valley' },
          { type: 'placeauthorities', subtype: 'place', value: 'Hamilton!, Ohio' },
          { type: 'placeauthorities', subtype: 'place', value: '姫路城' },
          { type: 'placeauthorities', subtype: 'place', value: "No'Where" },
          { type: 'personauthorities', subtype: 'person', value: 'Morris, Perry(Pete)' },
          { type: 'personauthorities', subtype: 'person', value: 'Clark, H. Pol & Mary Gambo' },
          { type: 'orgauthorities', subtype: 'organization', value: "Smith's Appletree Garager" },
          { type: 'orgauthorities', subtype: 'organization', value: 'The "Grand" Canyon' }
        ]
        results = args.map { |arg| client.find(arg) }
                      .map { |resp| resp.parsed['abstract_common_list']['list_item']['uri'] }
        expected = [
          '/placeauthorities/838dbc1c-12f0-45fa-9a26/items/40adef7a-aadc-4743-b2ed',
          '/placeauthorities/838dbc1c-12f0-45fa-9a26/items/e4f1148d-1790-417c-ab7a',
          '/placeauthorities/838dbc1c-12f0-45fa-9a26/items/c9d34920-1782-49ed-a0c3',
          '/placeauthorities/838dbc1c-12f0-45fa-9a26/items/4745b7b1-cc7a-458e-9742',
          '/placeauthorities/838dbc1c-12f0-45fa-9a26/items/a0f4ba2a-07cb-4647-a884',
          '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2f050460-984b-49d7-b6df',
          '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/699abb7c-9a14-48cc-a975',
          '/orgauthorities/5225cf0b-d288-41ab-b2ea/items/02ed1508-9a29-451e-a08b',
          '/orgauthorities/5225cf0b-d288-41ab-b2ea/items/bf51a88c-2eae-48d6-9405'
        ]
        expect(results).to eq(expected)
      end
    end

    context 'with vocabulary and operator = ILIKE' do
      # actual value is 'additional taxa'
      let(:args) do
        { type: 'vocabularies', subtype: 'annotationtype', value: 'Additional Taxa', operator: 'ILIKE' }
      end
      it 'finds as expected' do
        expect(result).to eq('/vocabularies/e1401111-05c2-4d6c-bdc5/items/84c82c13-9d46-48a9-a8b9')
      end
    end

    context 'with vocabulary and operator = LIKE' do
      # actual value is 'additional taxa'
      let(:args) do
        { type: 'vocabularies', subtype: 'annotationtype', value: 'additional %', operator: 'LIKE' }
      end
      it 'finds as expected' do
        expect(result).to eq('/vocabularies/e1401111-05c2-4d6c-bdc5/items/84c82c13-9d46-48a9-a8b9')
      end
    end
  end

  describe '#find_relation' do
    let(:client) { default_client }
    let(:response) { client.find_relation(args) }
    let(:result) { response.parsed['relations_common_list']['relation_list_item']['uri'] }
    context 'with object hierarchy' do
      let(:args) { { subject_csid: '16161bff-b01a-4b55-95aa', object_csid: '34bb1c08-5f46-4347-94db', rel_type: 'hasBroader' } }
      it 'finds as expected' do
        expect(result).to eq('/relations/e23631b8-a977-46b8-b4b9')
      end
    end

    context 'with authority hierarchy' do
      let(:args) { { subject_csid: 'e4f1148d-1790-417c-ab7a', object_csid: '40adef7a-aadc-4743-b2ed', rel_type: 'hasBroader' } }
      it 'finds as expected' do
        expect(result).to eq('/relations/1a35c85f-a549-48ec-bfc3')
      end
    end

    context 'with non-hierarchical relation' do
      let(:args) { { subject_csid: '56c04f5f-32b9-4f1d-8a4b', object_csid: '6f0ce7b3-0130-444d-8633', rel_type: 'affects' } }
      it 'finds as expected' do
        expect(result).to eq('/relations/53b4a988-cd8a-4299-9ae7')
      end
    end

    context 'with no reltype given' do
      let(:args) { { subject_csid: '56c04f5f-32b9-4f1d-8a4b', object_csid: '6f0ce7b3-0130-444d-8633' } }
      it 'finds as expected' do
        expect(result).to eq('/relations/53b4a988-cd8a-4299-9ae7')
      end
    end
  end

  describe '#keyword_search' do
    let(:client) { default_client }
    it 'finds as expected' do
      args = [
        { type: 'vocabularies', subtype: 'annotationtype', value: 'Additional taxa' },
        { type: 'vocabularies', subtype: 'annotationtype', value: 'ADDITIONAL TAXA' },
        { type: 'collectionobjects', value: 'tea' },
        { type: 'collectionobjects', value: 'set' },
        { type: 'collectionobjects', value: 'tea set' },
        { type: 'personauthorities', subtype: 'person', value: 'A.' },
        { type: 'personauthorities', subtype: 'person', value: 'P' },
        { type: 'personauthorities', subtype: 'person', value: 'Q.' },
        { type: 'personauthorities', subtype: 'person', value: 'Colet' },
        { type: 'personauthorities', subtype: 'person', value: 'Linda' },
        { type: 'personauthorities', subtype: 'person', value: 'Linda Colet' }

      ]
      results = args.map { |arg| client.keyword_search(arg) }
                    .map { |response| response.parsed['abstract_common_list']['list_item'] }
                    .map { |list| list.is_a?(Hash) ? [list] : list } # handle single item returned
                    .map { |list| list.nil? ? [{}] : list } # handle no items returned
                    .map { |list| list.map { |item| item['uri'] } }
                    .flatten

      expected = [
        '/vocabularies/e1401111-05c2-4d6c-bdc5/items/84c82c13-9d46-48a9-a8b9',
        '/vocabularies/e1401111-05c2-4d6c-bdc5/items/84c82c13-9d46-48a9-a8b9',
        '/collectionobjects/ac04b8a6-db59-433e-872f',
        '/collectionobjects/8b21c9af-1fab-4708-91d4',
        '/collectionobjects/16e51d6a-5ae3-4716-bd0f',
        '/collectionobjects/bf51110a-0666-47b8-b9d4',
        '/collectionobjects/77c07515-c0e3-4b76-aeea',
        '/collectionobjects/bf51110a-0666-47b8-b9d4',
        '/collectionobjects/bf51110a-0666-47b8-b9d4',
        nil,
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/f7464b3c-f2a9-4c7a-bf5d',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2661dcf8-f184-41db-b032',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2c4e4938-482d-4574-946b',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/e4b4c37c-9243-4eb4-807b',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/e0e83104-85bc-48ba-acef',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/7b110f01-acac-4742-bdf0',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2fd23671-b476-4f67-b548',
        '/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df'
      ]
      expect(results).to eq(expected)
    end
  end

  describe '#reset_media_blob' do
    let(:client) { default_client }
    context 'with an invalid url' do
      let(:id) { 'DTS.1' }
      let(:url) { 'not_a_url' }
      it 'will report an argument error' do
        expect { client.reset_media_blob(id, url) }.to raise_error(CollectionSpace::ArgumentError)
      end
    end

    context 'with no matching media record' do
      let(:id) { 'DTS.does_not_exist' }
      let(:url) { 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' }
      it 'will report a not found error' do
        expect { client.reset_media_blob(id, url) }.to raise_error(CollectionSpace::NotFoundError)
      end
    end

    context 'with multiple matching media records' do
      let(:id) { 'DTS.dupes' }
      let(:url) { 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' }
      it 'will report a duplicate id error' do
        expect { client.reset_media_blob(id, url) }.to raise_error(CollectionSpace::DuplicateIdFound)
      end
    end

    context 'with a matching media record' do
      let(:id) { 'DTS.1' }
      let(:url) { 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' }
      it 'will reset the media blob record' do
        response  = client.find(type: 'media', value: id, field: 'identificationNumber')
        blob_csid = response.parsed['abstract_common_list']['list_item']['blobCsid']
        response  = client.reset_media_blob(id, url)
        expect(response.result.success?).to be true
        expect(response.parsed['document']['media_common']['blobCsid']).to_not eq blob_csid
      end
    end
  end
end
