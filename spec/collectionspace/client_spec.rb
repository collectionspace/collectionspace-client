require 'spec_helper'

describe CollectionSpace::Client do

  let(:client) { CollectionSpace::Client.new }

  describe "Configuration" do

    it 'will use the default configuration if none is provided' do
      client = CollectionSpace::Client.new
      expect(client.config.base_uri).to eq DEFAULT_BASE_URI
    end

    it 'will raise an error if supplied configuration is of invalid type' do
      expect{ CollectionSpace::Client.new({ base_uri: CUSTOM_BASE_URI }) }.to raise_error(RuntimeError)
    end

    it 'will allow a configuration object to be provided' do
      client = CollectionSpace::Client.new(CollectionSpace::Configuration.new({ base_uri: CUSTOM_BASE_URI }))
      expect(client.config.base_uri).to eq CUSTOM_BASE_URI
    end

  end

  describe "Client" do

    let(:collectionobjects_request) { -> {
        response = client.get('collectionobjects')
        total    = response.parsed['abstract_common_list']['totalItems'].to_i
        return response, total
      }
    }

    it "can request collectionobjects" do
      VCR.use_cassette('collectionobjects_get') do
        response, total = collectionobjects_request.call
        expect(response.status_code).to eq(200)
      end
    end

    it "can count collectionobjects" do
      VCR.use_cassette('collectionobjects_count') do
        response, total = collectionobjects_request.call
        count           = client.count 'collectionobjects'
        expect(response.status_code).to eq(200)
        expect(count).to eq(total)
      end
    end

    it "can retrieve all collectionobjects" do
      VCR.use_cassette('collectionobjects_all') do
        response, total = collectionobjects_request.call
        collectionobjects = client.all('collectionobjects')
        expect(response.status_code).to eq(200)
        expect(collectionobjects.size).to eq(total)
      end
    end

  end

  describe "Helpers" do
  end

  describe "Version information" do

    it 'has a version number' do
      expect(CollectionSpace::Client::VERSION).not_to be nil
    end

  end

end
