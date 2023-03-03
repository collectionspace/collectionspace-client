# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "collectionspace/client"

STANDARD_TENANTS = [
  :anthro,
  :bonsai,
  :botgarden,
  :core,
  :fcart,
  :herbarium,
  :lhmc,
  :materials,
  :publicart
]

# https://github.com/collectionspace/Tools/blob/master/scripts/install_report_records.sh
# https://github.com/collectionspace/Tools/blob/master/scripts/create-report-records.sh

STANDARD_REPORTS = [
  {
    name: "Acquisition Summary",
    notes: "An acquisition summary report. Runs on a single record only.",
    doctype: "Acquisition",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "acq_basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Acquisition Basic List",
    notes: "Catalog info for objects related to an acquisition record. Runs on a single record only.",
    doctype: "Acquisition",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "Acq_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Condition Check Basic List",
    notes: "Catalog info for objects related to a condition check record. Runs on a single record only.",
    doctype: "Conditioncheck",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "CC_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Exhibition Basic List",
    notes: "Catalog info for objects related to a exhibition record. Runs on a single record only.",
    doctype: "Exhibition",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "Exhibition_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Group Basic List",
    notes: "Catalog info for objects related to a group record. Runs on a single record only.",
    doctype: "Group",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "Group_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Loan In Basic List",
    notes: "Catalog info for objects related to a loan in record. Runs on a single record only.",
    doctype: "Loanin",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "LoansIn_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Loan Out Basic List",
    notes: "Catalog info for objects related to a loan out record. Runs on a single record only.",
    doctype: "Loanout",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "LoansOut_List_Basic.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Acquisition Ethnographic Object List",
    notes: "Core acquisition report. Runs on a single record only.",
    doctype: "Acquisition",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreAcquisition.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Group Object Ethnographic Object List",
    notes: "Core group object report. Runs on a single record only.",
    doctype: "Group",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreGroupObject.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Intake Ethnographic Object List",
    notes: "Core intake report. Runs on a single record only.",
    doctype: "Intake",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreIntake.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Loan In Ethnographic Object List",
    notes: "Core loan in report. Runs on a single record only.",
    doctype: "Loanin",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreLoanIn.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Loan Out Ethnographic Object List",
    notes: "Core loan out report. Runs on a single record only.",
    doctype: "Loanout",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreLoanOut.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Object Exit Ethnographic Object List",
    notes: "Core object exit report. Runs on a single record only.",
    doctype: "ObjectExit",
    supports_single_doc: "true",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "false",
    filename: "coreObjectExit.jrxml",
    mimetype: "application/pdf"
  },
  {
    name: "Object Valuation",
    notes: "Returns latest valuation information for selected objects",
    doctype: "CollectionObject",
    supports_single_doc: "false",
    supports_doc_list: "true",
    supports_group: "false",
    supports_no_context: "true",
    filename: "object_valuation.jrxml",
    mimetype: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  },
  {
    name: "Systematic Inventory",
    notes: "Generate a checklist for performing an inventory on a range of storage locations. Runs on all records, using the provided start and end locations.",
    doctype: "Locationitem",
    supports_single_doc: "false",
    supports_doc_list: "false",
    supports_group: "false",
    supports_no_context: "true",
    filename: "systematicInventory.jrxml",
    mimetype: "application/pdf"
  }
]

STANDARD_TENANTS.each do |tenant|
  client = CollectionSpace::Client.new(
    CollectionSpace::Configuration.new(
      base_uri: "https://#{tenant}.dev.collectionspace.org/cspace-services",
      username: "admin@#{tenant}.collectionspace.org",
      password: "Administrator"
    )
  )

  STANDARD_REPORTS.each do |report|
    response = client.add_report(report)
    puts response.inspect
  end
end
