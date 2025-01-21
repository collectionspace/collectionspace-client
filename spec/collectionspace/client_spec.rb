# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Client do
  let(:base) { "https://core.dev.collectionspace.org/cspace-services" }

  describe ".new" do
    it "will use the default configuration if none is provided" do
      client = CollectionSpace::Client.new
      expect(client.config.base_uri).to eq nil
    end

    it "will raise an error if supplied configuration is of invalid type" do
      expect { CollectionSpace::Client.new(base_uri: base) }.to raise_error(
        CollectionSpace::ArgumentError,
        "Invalid configuration object"
      )
    end

    it "will allow a configuration object to be provided" do
      expect(no_authentication_client.config.base_uri).to eq(base)
    end
  end

  describe "#can_authenticate?" do
    let(:result) { CollectionSpace::Client.new(config).can_authenticate? }

    context "when username/password are not given" do
      let(:config) { no_authentication_config }

      it "returns false" do
        expect(result).to be false
      end
    end

    context "when valid username/password given" do
      let(:config) { default_config }

      it "returns true" do
        VCR.use_cassette("client_check_auth_success") do
          expect(result).to be true
        end
      end
    end

    context "when username not in instance" do
      let(:config) do
        CollectionSpace::Configuration.new(
          base_uri: "https://core.dev.collectionspace.org/cspace-services",
          username: "notadmin@core.collectionspace.org",
          password: "Administrator"
        )
      end

      it "returns false" do
        VCR.use_cassette("client_check_auth_bad_user") do
          expect(result).to be false
        end
      end
    end

    context "when bad password given" do
      let(:config) do
        CollectionSpace::Configuration.new(
          base_uri: "https://core.dev.collectionspace.org/cspace-services",
          username: "admin@core.collectionspace.org",
          password: "nope"
        )
      end

      it "returns false" do
        VCR.use_cassette("client_check_auth_bad_password") do
          expect(result).to be false
        end
      end
    end
  end

  describe "#get" do
    let(:client) { default_client }

    it "can request collectionobjects" do
      VCR.use_cassette("client_collectionobjects_get") do
        response, = request_with_total("collectionobjects")
        expect(response.status_code).to eq(200)
      end
    end
  end

  describe "#count" do
    let(:client) { default_client }

    it "can count collectionobjects" do
      VCR.use_cassette("client_collectionobjects_count") do
        response, total = request_with_total("collectionobjects")
        count = client.count "collectionobjects"
        expect(response.status_code).to eq(200)
        expect(count).to eq(total)
      end
    end
  end

  describe "#all" do
    let(:client) { default_client }

    it "can retrieve all collectionobjects" do
      VCR.use_cassette("client_collectionobjects_all") do
        response, total = request_with_total("collectionobjects")
        results = []
        client.all("collectionobjects").each do |r|
          results << r
        end
        expect(response.status_code).to eq(200)
        expect(results.size).to eq total
      end
    end
  end

  describe "#service" do
    it "can retrieve services" do
      client = no_authentication_client
      service = client.service(type: "collectionobjects")
      expect(service[:identifier]).to eq "objectNumber"
      expect(service[:path]).to eq "collectionobjects"
      expect(service[:term]).to be_nil
    end
  end
end
