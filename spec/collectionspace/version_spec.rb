require 'spec_helper'

describe CollectionSpace::Client do
  describe 'Version information' do
    it 'has a version number' do
      expect(CollectionSpace::Client::VERSION).not_to be nil
    end
  end
end
