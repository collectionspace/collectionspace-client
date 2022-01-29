# frozen_string_literal: true

require 'spec_helper'

describe CollectionSpace::RefName do
  let(:refname_collectionobject) do
    "urn:cspace:core.collectionspace.org:collectionobjects:id(09f531bd-4f12-4c36-9f92)'Loaned object 1'"
  end
  let(:refname_procedure) do
    'urn:cspace:core.collectionspace.org:acquisitions:id(5043d8cc-9437-4bc7-92d1)'
  end
  let(:refname_relation) do
    'urn:cspace:core.collectionspace.org:relations:id(da044bc2-9fbf-474d-803a)'
  end
  let(:refname_authority) do
    "urn:cspace:core.collectionspace.org:personauthorities:name(person)'Local Persons'"
  end
  let(:refname_person) do
    "urn:cspace:core.collectionspace.org:personauthorities:name(person):item:name(1234561562130996026)'123456'"
  end
  let(:refname_with_colon_in_name) do
    "urn:cspace:core.collectionspace.org:locationauthorities:name(location):item:name(AR1U1Shelf14078111602)'A:R1:U1:Shelf 1'"
  end
  let(:refname_with_parens) do
    "urn:cspace:core.collectionspace.org:conceptauthorities:name(concept):item:name(JMAlexanderCompanyAtlantaGa1028284796)'J.M. Alexander & Company (Atlanta, Ga.)'"
  end

  it 'can parse a collectionobject refname' do
    expect(CollectionSpace::RefName.parse(refname_collectionobject)).to eq({
                                                                             domain: 'core.collectionspace.org',
                                                                             type: 'collectionobjects',
                                                                             subtype: nil,
                                                                             identifier: '09f531bd-4f12-4c36-9f92',
                                                                             label: 'Loaned object 1'
                                                                           })
  end

  it 'can parse a procedure refname' do
    expect(CollectionSpace::RefName.parse(refname_procedure)).to eq({
                                                                      domain: 'core.collectionspace.org',
                                                                      type: 'acquisitions',
                                                                      subtype: nil,
                                                                      identifier: '5043d8cc-9437-4bc7-92d1',
                                                                      label: nil
                                                                    })
  end

  it 'can parse a relation refname' do
    expect(CollectionSpace::RefName.parse(refname_relation)).to eq({
                                                                     domain: 'core.collectionspace.org',
                                                                     type: 'relations',
                                                                     subtype: nil,
                                                                     identifier: 'da044bc2-9fbf-474d-803a',
                                                                     label: nil
                                                                   })
  end

  it 'can parse a top level authority refname' do
    expect(CollectionSpace::RefName.parse(refname_authority)).to eq({
                                                                      domain: 'core.collectionspace.org',
                                                                      type: 'personauthorities',
                                                                      subtype: 'person',
                                                                      identifier: nil,
                                                                      label: 'Local Persons'
                                                                    })
  end

  it 'can parse an authority term refname' do
    expect(CollectionSpace::RefName.parse(refname_person)).to eq({
                                                                   domain: 'core.collectionspace.org',
                                                                   type: 'personauthorities',
                                                                   subtype: 'person',
                                                                   identifier: '1234561562130996026',
                                                                   label: '123456'
                                                                 })
  end

  it 'can parse an authority term with colon' do
    expect(CollectionSpace::RefName.parse(refname_with_colon_in_name)).to eq({
                                                                               domain: 'core.collectionspace.org',
                                                                               type: 'locationauthorities',
                                                                               subtype: 'location',
                                                                               identifier: 'AR1U1Shelf14078111602',
                                                                               label: 'A:R1:U1:Shelf 1'
                                                                             })
  end

  it 'can parse an authority term with parens' do
    expect(CollectionSpace::RefName.parse(refname_with_parens)).to eq({
                                                                        domain: 'core.collectionspace.org',
                                                                        type: 'conceptauthorities',
                                                                        subtype: 'concept',
                                                                        identifier: 'JMAlexanderCompanyAtlantaGa1028284796',
                                                                        label: 'J.M. Alexander & Company (Atlanta, Ga.)'
                                                                      })
  end
end
