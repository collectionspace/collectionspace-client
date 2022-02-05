# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Search do
  let(:search_args) do
    {
      path: 'groups',
      namespace: 'groups_common',
      field: 'title',
      expression: "ILIKE '%D%'"
    }
  end
  it 'can construct search from a hash' do
    search = CollectionSpace::Search.new(**search_args)
    expect(search.path).to eq(search_args[:path])
    expect(search.namespace).to eq(search_args[:namespace])
    expect(search.field).to eq(search_args[:field])
    expect(search.expression).to eq(search_args[:expression])
  end

  it 'can add params for search' do
    client = CollectionSpace::Client.new(CollectionSpace::Configuration.new)
    allow(client).to receive(:request).and_return nil
    client.search(
      CollectionSpace::Search.new(**search_args),
      { sortBy: 'collectionspace_core:updatedAt DESC' }
    )
    expect(client).to have_received(:request).with(
      'GET', 'groups', {
        query: { as: "groups_common:title ILIKE '%D%'", sortBy: 'collectionspace_core:updatedAt DESC' }
      }
    )
  end
end
