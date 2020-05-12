require 'spec_helper'

describe CollectionSpace::Client do
  let(:base) { 'https://core.dev.collectionspace.org/cspace-services' }
  let(:client) { CollectionSpace::Client.new }

  describe 'Configuration' do
    it 'will use the default configuration if none is provided' do
      client = CollectionSpace::Client.new
      expect(client.config.base_uri).to eq nil
    end

    it 'will raise an error if supplied configuration is of invalid type' do
      expect { CollectionSpace::Client.new(base_uri: base) }.to raise_error
    end

    it 'will allow a configuration object to be provided' do
      client = CollectionSpace::Client.new(
        CollectionSpace::Configuration.new(base_uri: base)
      )
      expect(client.config.base_uri).to eq base
    end
  end

  describe 'Client' do
    let(:client) { default_client }

    it 'can request collectionobjects' do
      VCR.use_cassette('collectionobjects_get') do
        response, = request_with_total('collectionobjects')
        expect(response.status_code).to eq(200)
      end
    end

    it 'can count collectionobjects' do
      VCR.use_cassette('collectionobjects_count') do
        response, total = request_with_total('collectionobjects')
        count           = client.count 'collectionobjects'
        expect(response.status_code).to eq(200)
        expect(count).to eq(total)
      end
    end

    it 'can retrieve all collectionobjects' do
      VCR.use_cassette('collectionobjects_all') do
        response, = request_with_total('collectionobjects')
        results = []
        client.all('collectionobjects').each do |r|
          results << r
        end
        expect(response.status_code).to eq(200)
        expect(results.size).to eq 164
      end
    end
  end
end
