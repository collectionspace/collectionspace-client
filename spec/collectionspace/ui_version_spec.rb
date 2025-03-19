# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::UiVersion do
  subject(:getter) { described_class.new(client) }

  let(:client) do
    CollectionSpace::Client.new(
      CollectionSpace::Configuration.new(base_uri: uri)
    )
  end

  describe "#call" do
    let(:result) { getter.call }

    context "with core" do
      let(:uri) { "https://core.collectionspace.org/cspace-services" }

      it "returns version" do
        VCR.use_cassette("ui_version_core") do
          expect(result.success?).to be true
          expect(result.joined).to eq("core 9.0.1")
        end
      end
    end

    context "with anthro" do
      let(:uri) { "https://anthro.dev.collectionspace.org/cspace-services" }
      it "returns version" do
        VCR.use_cassette("ui_version_anthro") do
          expect(result.status).to eq(:success)
          expect(result.profile).to eq("anthro")
          expect(result.version).to eq("3a22c87")
        end
      end
    end

    context "with ccp" do
      let(:uri) { "https://ccp.collectionspace.org/cspace-services" }
      it "returns version" do
        VCR.use_cassette("ui_version_ccp") do
          expect(result.status).to eq(:success)
          expect(result.profile).to eq("fcart")
          expect(result.version).to eq("7.0.0")
        end
      end
    end

    context "with ohc" do
      let(:uri) { "https://ohiohistory.collectionspace.org/cspace-services" }
      it "returns version" do
        VCR.use_cassette("ui_version_ohc") do
          expect(result.status).to eq(:success)
          expect(result.profile).to eq("ohc")
          expect(result.version).to eq("2.0.1")
        end
      end
    end

    context "with UCB PAHMA" do
      let(:uri) { "https://pahma.collectionspace.org/cspace-services" }
      it "returns version" do
        VCR.use_cassette("ui_version_pahma") do
          expect(result.status).to eq(:success)
          expect(result.profile).to eq("pahma")
          expect(result.version).to eq("4.0.0-rc.4")
        end
      end
    end

    context "with bad URL" do
      let(:uri) { "https://anthor.collectionspace.org/cspace-services" }
      it "returns failure value" do
        VCR.use_cassette("ui_version_anthor") do
          expect(result.failure?).to be true
          expect(result.message).to start_with(
            "Failed to open TCP connection to " \
              "anthor.collectionspace.org:443 (getaddrinfo: "
          )
          expect(result.joined).to be_nil
        end
      end
    end

    context "with non-CollectionSpace services base URL" do
      let(:uri) { "https://collectionspace.org" }
      it "returns failure value" do
        VCR.use_cassette("ui_version_cs") do
          expect(result.status).to eq(:failure)
          expect(result.message).to eq(
            "No CollectionSpace UI plugin script sources detected for " \
              "https://collectionspace.org"
          )
        end
      end
    end
  end
end
