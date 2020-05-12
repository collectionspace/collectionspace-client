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
end
