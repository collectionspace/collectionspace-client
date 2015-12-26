require 'spec_helper'

describe CollectionSpace::Configuration do

  it 'uses the project demo site for configuration defaults' do
    config = CollectionSpace::Configuration.new
    expect(config.base_uri).to eq DEFAULT_BASE_URI
  end

  it 'allows configuration settings to be provided' do
    config = CollectionSpace::Configuration.new({
      base_uri: CUSTOM_BASE_URI,
    })
    expect(config.base_uri).to eq CUSTOM_BASE_URI
  end

  it 'allows the configuration properties to be updated' do
    config = CollectionSpace::Configuration.new
    config.base_uri = CUSTOM_BASE_URI
    expect(config.base_uri).to eq CUSTOM_BASE_URI
  end

  it 'ignores unrecognized configuration properties' do
    config = CollectionSpace::Configuration.new({ xyz: 123 })
    expect{ config.xyz }.to raise_error(NoMethodError)
  end

end