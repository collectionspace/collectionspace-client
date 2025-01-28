# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Helpers do
  let(:client) { CollectionSpace::Client.new }

  describe "#authority_doctypes" do
    let(:client) { default_client }
    let(:result) { client.authority_doctypes }

    it "returns Array of authority doctypes" do
      VCR.use_cassette("helpers_authority_doctypes") do
        expected = ["Chronology", "Citation", "Conceptitem", "Locationitem",
          "Organization", "Person", "Placeitem", "Workitem"]
        expect(result.sort).to eq(expected)
      end
    end
  end

  describe "#get_list_types" do
    let(:result) { client.get_list_types(type) }
    context "with accounts" do
      let(:type) { "accounts" }
      it "can get accounts list type" do
        expect(result).to eq(
          %w[accounts_common_list account_list_item]
        )
      end
    end

    context "with regular type" do
      let(:type) { "media" }
      it "can get regular list type" do
        expect(result).to eq(
          %w[abstract_common_list list_item]
        )
      end
    end

    context "with relations" do
      let(:type) { "relations" }
      it "can get relations list type" do
        expect(result).to eq(
          %w[relations_common_list relation_list_item]
        )
      end
    end
  end

  describe "#domain" do
    let(:client) { CollectionSpace::Client.new(CollectionSpace::Configuration.new) }
    it "can get the client domain" do
      refname = "urn:cspace:core.collectionspace.org:personauthorities:name(ulan_pa)'ULAN Persons'"
      body = %({ "abstract_common_list": { "list_item": { "refName": "#{refname}" } } })
      allow(client).to receive(:request).and_return CollectionSpace::Response.new(
        OpenStruct.new(
          code: "200",
          body: body,
          parsed_response: JSON.parse(body),
          success?: true
        )
      )
      expect(client.domain).to eq("core.collectionspace.org")
    end
  end

  describe "#find" do
    let(:client) { default_client }
    let(:response) { client.find(**args) }
    let(:result) { response.parsed["abstract_common_list"]["list_item"]["uri"] }

    context "with object" do
      let(:args) { {type: "collectionobjects", value: "OBJ A"} }
      it "finds as expected" do
        VCR.use_cassette("helpers_find_with_collectionobject") do
          expect(result).to eq("/collectionobjects/b08af938-842c-4650-82eb")
        end
      end
    end

    context "with authority term" do
      it "finds as expected" do
        args = [
          {type: "placeauthorities", subtype: "place", value: "California"},
          {type: "placeauthorities", subtype: "place", value: "Death Valley"},
          {type: "placeauthorities", subtype: "place", value: "Hamilton!, Ohio"},
          {type: "placeauthorities", subtype: "place", value: "姫路城"},
          {type: "placeauthorities", subtype: "place", value: "No'Where"},
          {type: "personauthorities", subtype: "person", value: "Morris, Perry(Pete)"},
          {type: "personauthorities", subtype: "person", value: "Clark, H. Pol & Mary Gambo"},
          {type: "orgauthorities", subtype: "organization", value: "Smith's Appletree Garager"},
          {type: "orgauthorities", subtype: "organization", value: 'The "Grand" Canyon'}
        ]
        VCR.use_cassette("helpers_find_with_authority_term") do
          results = args.map { |arg| client.find(**arg) }
            .map { |resp| resp.parsed["abstract_common_list"]["list_item"]["uri"] }
            .map { |uri| uri.split("/").last }
          expected = [
            "147c4944-fe0c-4e88-80b0",
            "abf45754-f9d2-4588-bb64",
            "d9bf40cf-841e-43b1-bbee",
            "e036b409-a7f5-4eff-a030",
            "de602169-fe35-4093-865a",
            "dcc1969c-9340-4980-86e7",
            "f4df08f5-5503-4d41-856c",
            "d2d0a377-b29c-4beb-aab4",
            "c96240b6-e294-4749-9e6c"
          ]
          expect(results).to eq(expected)
        end
      end
    end

    context "with vocabulary and operator = ILIKE" do
      # actual value is 'additional taxa'
      let(:args) do
        {type: "vocabularies", subtype: "annotationtype", value: "Additional Taxa", operator: "ILIKE"}
      end
      it "finds as expected" do
        VCR.use_cassette("helpers_find_with_ilike") do
          expect(result).to eq("/vocabularies/985afe4a-0740-44a0-91bd/items/0a832685-97bd-42aa-ab6d")
        end
      end
    end

    context "with vocabulary and operator = LIKE" do
      # actual value is 'additional taxa'
      let(:args) do
        {type: "vocabularies", subtype: "annotationtype", value: "additional %", operator: "LIKE"}
      end
      it "finds as expected" do
        VCR.use_cassette("helpers_find_with_like") do
          expect(result).to eq("/vocabularies/985afe4a-0740-44a0-91bd/items/0a832685-97bd-42aa-ab6d")
        end
      end
    end
  end

  describe "#find_relation" do
    let(:client) { default_client }
    let(:response) { client.find_relation(**args) }
    let(:result) { response.parsed["relations_common_list"]["relation_list_item"]["uri"] }
    context "with object hierarchy" do
      let(:args) do
        {subject_csid: "f1767589-0b0f-4066-a4c6",
         object_csid: "b08af938-842c-4650-82eb",
         rel_type: "hasBroader"}
      end
      it "finds as expected" do
        VCR.use_cassette("helpers_find_object_hierarchy") do
          expect(result).to eq("/relations/1323c360-d919-4209-b069")
        end
      end
    end

    context "with non-hierarchical relation" do
      let(:args) do
        {subject_csid: "f7d3be87-8864-477a-8098",
         object_csid: "b08af938-842c-4650-82eb",
         rel_type: "affects"}
      end

      it "finds as expected" do
        VCR.use_cassette("helpers_find_non_hierarchical_relation") do
          expect(result).to eq("/relations/7ff97301-13e4-4b5f-a5e7")
        end
      end
    end

    context "with no reltype given" do
      let(:args) do
        {subject_csid: "f7d3be87-8864-477a-8098",
         object_csid: "b08af938-842c-4650-82eb"}
      end

      it "finds as expected" do
        VCR.use_cassette("helpers_find_with_no_reltype") do
          expect(result).to eq("/relations/7ff97301-13e4-4b5f-a5e7")
        end
      end

      it "warns" do
        msg = "No rel_type specified, so multiple types of relations between f7d3be87-8864-477a-8098 and b08af938-842c-4650-82eb may be returned"
        VCR.use_cassette("helpers_find_with_no_reltype") do
          expect(client).to receive(:warn).with(msg, uplevel: 1)
          response
        end
      end
    end
  end

  describe "#keyword_search" do
    let(:client) { default_client }
    it "finds as expected" do
      args = [
        {type: "vocabularies", subtype: "annotationtype", value: "Additional taxa"},
        {type: "vocabularies", subtype: "annotationtype", value: "ADDITIONAL TAXA"}
      ]
      VCR.use_cassette("helpers_find_keyword_search") do
        results = args.map { |arg| client.keyword_search(**arg) }
          .map { |response| response.parsed["abstract_common_list"]["list_item"] }
          .map { |list| list.is_a?(Hash) ? [list] : list } # handle single item returned
          .map { |list| list.nil? ? [{}] : list } # handle no items returned
          .map { |list| list.map { |item| item["uri"] } }
          .flatten

        expected = [
          "/vocabularies/985afe4a-0740-44a0-91bd/items/0a832685-97bd-42aa-ab6d",
          "/vocabularies/985afe4a-0740-44a0-91bd/items/0a832685-97bd-42aa-ab6d"
        ]
        expect(results).to eq(expected)
      end
    end

    it "finds as expected", pending: "These are extracted from the previous " \
      "test and are failing because the original test values no longer exist " \
      "in core.dev. The way the test was written, it's hard to tell exactly " \
      "what is supposed to be tested by each of these cases, so it's not " \
      "clear how to re-create these tests. Also these appear to mainly test " \
      "the functionality of keyword search via the API, *not* this app, " \
      "since they are all called/processed exactly the same way. There's a " \
      "value to that maybe, given the lack of clear documentation re: api, " \
      "but I'm not sure maintaining hard-to-maintain tests about it here is " \
      "the way to go forward" do
      args = [
        {type: "collectionobjects", value: "tea"},
        {type: "collectionobjects", value: "set"},
        {type: "collectionobjects", value: "tea set"},
        {type: "personauthorities", subtype: "person", value: "A."},
        {type: "personauthorities", subtype: "person", value: "P"},
        {type: "personauthorities", subtype: "person", value: "Q."},
        {type: "personauthorities", subtype: "person", value: "Colet"},
        {type: "personauthorities", subtype: "person", value: "Linda"},
        {type: "personauthorities", subtype: "person", value: "Linda Colet"}

      ]
      VCR.use_cassette("helpers_find_keyword_search") do
        results = args.map { |arg| client.keyword_search(**arg) }
          .map { |response| response.parsed["abstract_common_list"]["list_item"] }
          .map { |list| list.is_a?(Hash) ? [list] : list } # handle single item returned
          .map { |list| list.nil? ? [{}] : list } # handle no items returned
          .map { |list| list.map { |item| item["uri"] } }
          .flatten

        expected = [
          "/collectionobjects/8b21c9af-1fab-4708-91d4",
          "/collectionobjects/ac04b8a6-db59-433e-872f",
          "/collectionobjects/16e51d6a-5ae3-4716-bd0f",
          "/collectionobjects/bf51110a-0666-47b8-b9d4",
          "/collectionobjects/77c07515-c0e3-4b76-aeea",
          "/collectionobjects/bf51110a-0666-47b8-b9d4",
          "/collectionobjects/bf51110a-0666-47b8-b9d4",
          nil,
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/f7464b3c-f2a9-4c7a-bf5d",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2661dcf8-f184-41db-b032",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2c4e4938-482d-4574-946b",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/e4b4c37c-9243-4eb4-807b",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/e0e83104-85bc-48ba-acef",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/7b110f01-acac-4742-bdf0",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/2fd23671-b476-4f67-b548",
          "/personauthorities/0f6cddfa-32ce-4c25-9b2f/items/67235e6f-5fc1-4319-b4df"
        ]
        expect(results).to eq(expected)
      end
    end
  end

  describe "#reset_media_blob" do
    let(:client) { default_client }
    let(:result) { client.reset_media_blob(id: id, url: url) }

    context "with an invalid url" do
      let(:id) { "DTS.1" }
      let(:url) { "not_a_url" }
      it "will report an argument error" do
        VCR.use_cassette("helpers_reset_media_blob_invalid_url") do
          expect { result }.to raise_error(CollectionSpace::ArgumentError)
        end
      end
    end

    context "with no matching media record" do
      let(:id) { "DTS.does_not_exist" }
      let(:url) { "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png" }
      it "will report a not found error" do
        VCR.use_cassette("helpers_reset_media_blob_does_not_exist") do
          expect { result }.to raise_error(CollectionSpace::NotFoundError)
        end
      end
    end

    context "with multiple matching media records" do
      let(:id) { "DTS.dupes" }
      let(:url) { "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png" }
      it "will report a duplicate id error" do
        VCR.use_cassette("helpers_reset_media_blob_duplicate") do
          expect { result }.to raise_error(CollectionSpace::DuplicateIdFound)
        end
      end
    end

    context "with a matching media record" do
      let(:id) { "DTS.1" }
      let(:url) { "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png" }
      it "will reset the media blob record" do
        VCR.use_cassette("helpers_reset_media_blob_success") do
          response = client.find(type: "media", value: id, field: "identificationNumber")
          blob_csid = response.parsed["abstract_common_list"]["list_item"]["blobCsid"]
          expect(result.result.success?).to be true
          expect(result.parsed["document"]["media_common"]["blobCsid"]).to_not eq blob_csid
        end
      end
    end
  end
end
