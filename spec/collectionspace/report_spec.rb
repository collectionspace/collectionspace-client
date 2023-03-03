# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Report do
  it "can retrieve a list of reports" do
    expect(CollectionSpace::Report.all).to_not be_empty
  end

  it "does not find a non-existent report" do
    report = CollectionSpace::Report.find(:name, "Nope.jrxml")
    expect(report).to be_nil
  end

  it "can find a report by name" do
    report = CollectionSpace::Report.find(:name, "Object Exit Ethnographic Object List")
    expect(report).to_not be_nil
    expect(report[:name]).to eq "Object Exit Ethnographic Object List"
    expect(report[:filename]).to eq "coreObjectExit.jrxml"
  end

  it "can find a report by filename" do
    report = CollectionSpace::Report.find(:filename, "coreLoanIn.jrxml")
    expect(report).to_not be_nil
    expect(report[:name]).to eq "Loan In Ethnographic Object List"
    expect(report[:filename]).to eq "coreLoanIn.jrxml"
  end
end
