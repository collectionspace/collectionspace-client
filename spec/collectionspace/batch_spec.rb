# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Batch do
  it "can retrieve a list of batches" do
    expect(CollectionSpace::Batch.all).to_not be_empty
  end

  it "does not find a non-existent batch" do
    batch = CollectionSpace::Batch.find(:name, "Nope, not a batch.")
    expect(batch).to be_nil
  end

  it "can find a batch by name" do
    batch = CollectionSpace::Batch.find(:name, "Update Current Location")
    expect(batch).to_not be_nil
    expect(batch[:name]).to eq "Update Current Location"
    expect(batch[:classname]).to eq "org.collectionspace.services.batch.nuxeo.UpdateObjectLocationBatchJob"
  end

  it "can find a batch by classname" do
    batch = CollectionSpace::Batch.find(:classname, "org.collectionspace.services.batch.nuxeo.MergeAuthorityItemsBatchJob")
    expect(batch).to_not be_nil
    expect(batch[:name]).to eq "Merge Authority Items"
    expect(batch[:classname]).to eq "org.collectionspace.services.batch.nuxeo.MergeAuthorityItemsBatchJob"
  end
end
