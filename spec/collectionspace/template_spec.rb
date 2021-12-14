# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::Template do
  it 'can list the default templates' do
    templates = CollectionSpace::Template.list
    expect(templates).to_not be_empty
    expect(templates).to include(/reindex_full_text.*erb/)
  end

  it 'can change the path when template envvar is set' do
    expect(CollectionSpace::Template.templates_path).to match(
      /#{File.join('lib', 'collectionspace', 'client', 'templates')}/
    )
    ENV['COLLECTIONSPACE_CLIENT_TEMPLATES_PATH'] = '/path/to/nowhere'
    expect(CollectionSpace::Template.templates_path).to eq '/path/to/nowhere'
    ENV.delete('COLLECTIONSPACE_CLIENT_TEMPLATES_PATH')
  end

  it 'can process a template' do
    xml = Nokogiri::XML.parse(CollectionSpace::Template.process(:reindex_full_text, {}))
    expect(xml.xpath('//name').text).to eq 'Reindex Full Text'

    xml = Nokogiri::XML.parse(
      CollectionSpace::Template.process(
        :reindex_by_doctype, {
          doctype: 'CollectionObject'
        }
      )
    )
    expect(xml.xpath('//docType').text).to eq 'CollectionObject'
  end
end
