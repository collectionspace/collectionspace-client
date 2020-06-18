# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Configuration do
  let(:base) { 'https://core.dev.collectionspace.org/cspace-services' }

  it 'sets the configuration defaults' do
    config = CollectionSpace::Configuration.new
    expect(config.base_uri).to eq nil
    expect(config.username).to eq nil
    expect(config.password).to eq nil
    expect(config.page_size).to eq 25
    expect(config.include_deleted).to eq false
    expect(config.throttle).to eq 0
    expect(config.verify_ssl).to eq true
  end

  it 'allows configuration settings to be provided' do
    config = CollectionSpace::Configuration.new(
      base_uri: base
    )
    expect(config.base_uri).to eq base
  end

  it 'allows the configuration properties to be updated' do
    config = CollectionSpace::Configuration.new
    config.base_uri = base
    expect(config.base_uri).to eq base
  end

  it 'ignores unrecognized configuration properties' do
    config = CollectionSpace::Configuration.new(xyz: 123)
    expect { config.xyz }.to raise_error(NoMethodError)
  end
end
