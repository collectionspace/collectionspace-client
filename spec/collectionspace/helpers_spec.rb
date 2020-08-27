# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Helpers do
  let(:client) { CollectionSpace::Client.new }
  it 'can get accounts list type' do
    expect(client.get_list_types('accounts')).to eq(
      %w[accounts_common_list account_list_item]
    )
  end

  it 'can get regular list type' do
    expect(client.get_list_types('media')).to eq(
      %w[abstract_common_list list_item]
    )
  end

  it 'can get relations list type' do
    expect(client.get_list_types('relations')).to eq(
      %w[relations_common_list relation_list_item]
    )
  end

  it 'can get the client domain' do
    client = CollectionSpace::Client.new(CollectionSpace::Configuration.new)
    body = '{ "abstract_common_list": { "list_item": { "refName": "urn:cspace:core.collectionspace.org:personauthorities:name(ulan_pa)\'ULAN Persons\'" } } }'
    allow(client).to receive(:request).and_return CollectionSpace::Response.new(
      OpenStruct.new(
        code: '200',
        body: body,
        parsed_response: JSON.parse(body),
        success?: true
      )
    )
    expect(client.domain).to eq("core.collectionspace.org")
  end
end
