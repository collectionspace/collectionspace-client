# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Request do
  let(:client) { default_client }
  let(:object_uri) { "collectionobjects/67e88be5-a498-4922-a90c" }
  let(:post_payload) { fixture("collectionobject.xml") }
  let(:post_file) { File.join("spec", "fixtures", "files", "tower.jpg") }
  let(:put_payload) { fixture("collectionobject_update.xml") }
  let(:search) do
    {
      path: "collectionobjects",
      namespace: "collectionobjects_common",
      field: "objectNumber",
      expression: "= 'CLIENT.002'"
    }
  end

  it "can create a collectionobject" do
    VCR.use_cassette("collectionobjects_create") do
      response = client.post("collectionobjects", post_payload)
      expect(response.status_code).to eq(201)
    end
  end

  it "can create a blob record" do
    VCR.use_cassette("blobs_create") do
      response = client.post_file(post_file)
      expect(response.status_code).to eq(201)
    end
  end

  it "raises an error creating a blob record if file is not found" do
    bad_file_path = "/this/file/does/not/exist.ext"
    expect(File.file?(bad_file_path)).to be false

    expect {
      client.post_file(bad_file_path)
    }.to raise_error CollectionSpace::ArgumentError, /#{bad_file_path}/
  end

  it "can read a collectionobject" do
    VCR.use_cassette("collectionobjects_read") do
      response = client.get(object_uri)
      expect(response.status_code).to eq(200)
    end
  end

  it "can update a collectionobject" do
    VCR.use_cassette("collectionobjects_update") do
      response = client.put(object_uri, put_payload)
      expect(response.status_code).to eq(200)
    end
  end

  it "can search for a collectionobject" do
    VCR.use_cassette("collectionobjects_search") do
      response = client.search(CollectionSpace::Search.new.from_hash(search))
      total = response.parsed["abstract_common_list"]["totalItems"].to_i
      expect(response.status_code).to eq(200)
      expect(total).to eq 1
    end
  end

  it "can delete a collectionobject" do
    VCR.use_cassette("collectionobjects_delete") do
      response = client.delete(object_uri)
      expect(response.status_code).to eq(200)
    end
  end
end
