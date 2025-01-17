# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Template do
  it "can list the default templates" do
    templates = CollectionSpace::Template.list
    expect(templates).to_not be_empty
    expect(templates).to include(/reindex_full_text.*erb/)
  end

  it "can change the path when template envvar is set" do
    expect(CollectionSpace::Template.templates_path).to match(
      /#{File.join("lib", "collectionspace", "client", "templates")}/
    )
    ENV["COLLECTIONSPACE_CLIENT_TEMPLATES_PATH"] = "/path/to/nowhere"
    expect(CollectionSpace::Template.templates_path).to eq "/path/to/nowhere"
    ENV.delete("COLLECTIONSPACE_CLIENT_TEMPLATES_PATH")
  end

  context "Report template" do
    it "can generate payload xml" do
      data = {name: "A brilliant report!", doctype: "CollectionObject", filename: "report.pdf"}
      xml = Nokogiri::XML.parse(CollectionSpace::Template.process(:report, data))

      expect(xml.xpath("//name").text).to eq data[:name]
      expect(xml.xpath("//forDocType").text).to eq data[:doctype]
      expect(xml.xpath("//filename").text).to eq data[:filename]
    end
  end

  context "Reindex template" do
    it "can generate reindex all payload xml" do
      data = {doctype: nil, csids: []}
      xml = Nokogiri::XML.parse(CollectionSpace::Template.process(:reindex, data))

      expect(xml.xpath("//mode").text).to eq "nocontext"
      expect(xml.xpath("//docType").text).to be_empty
    end

    it "can generate reindex by doctype payload xml" do
      data = {doctype: "CollectionObject", csids: []}
      xml = Nokogiri::XML.parse(CollectionSpace::Template.process(:reindex, data))

      expect(xml.xpath("//mode").text).to eq "nocontext"
      expect(xml.xpath("//docType").text).to eq "CollectionObject"
    end

    it "can generate reindex by doctype and csids payload xml" do
      data = {doctype: "CollectionObject", csids: ["123", "456"]}
      xml = Nokogiri::XML.parse(CollectionSpace::Template.process(:reindex, data))

      expect(xml.xpath("//mode").text).to eq "list"
      expect(xml.xpath("//docType").text).to eq "CollectionObject"
      expect(xml.xpath("//csid").text).to eq data[:csids].join("")
    end
  end
end
