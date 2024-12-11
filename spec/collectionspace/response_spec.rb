# frozen_string_literal: true

require "spec_helper"

describe CollectionSpace::Response do
  let :response do
    result = OpenStruct.new(
      code: 200,
      body: "",
      success?: true,
      parsed_response: {
        "abstract_common_list" =>
          {
            "pageNum" => "0",
            "pageSize" => "100",
            "itemsInPage" => "4",
            "totalItems" => "4",
            "fieldsReturned" => "csid|uri|refName|updatedAt|workflowState|name|createsNewFocus",
            "list_item" => [
              {
                "csid" => "733c5a43-9094-4bcf-9d7a",
                "uri" => "/batch/733c5a43-9094-4bcf-9d7a",
                "refName" => "urn:cspace:pacificbonsaimuseum.org:batch:id(733c5a43-9094-4bcf-9d7a)",
                "updatedAt" => "2024-11-13T17:41:29.494Z",
                "workflowState" => "project",
                "name" => "Reindex Full Text",
                "createsNewFocus" => "false"
              },
              {
                "csid" => "68f65633-1400-4be6-8db8",
                "uri" => "/batch/68f65633-1400-4be6-8db8",
                "refName" => "urn:cspace:pacificbonsaimuseum.org:batch:id(68f65633-1400-4be6-8db8)",
                "updatedAt" => "2023-03-04T03:55:03.875Z",
                "workflowState" => "project",
                "name" => "Merge Authority Items",
                "createsNewFocus" => "false"
              },
              {
                "csid" => "c4ea120f-9e14-42a5-a40f",
                "uri" => "/batch/c4ea120f-9e14-42a5-a40f",
                "refName" => "urn:cspace:pacificbonsaimuseum.org:batch:id(c4ea120f-9e14-42a5-a40f)",
                "updatedAt" => "2023-03-04T03:55:02.920Z",
                "workflowState" => "project",
                "name" => "Update Inventory Status",
                "createsNewFocus" => "false"
              },
              {
                "csid" => "59cecc98-b6e2-4db7-8665",
                "uri" => "/batch/59cecc98-b6e2-4db7-8665",
                "refName" => "urn:cspace:pacificbonsaimuseum.org:batch:id(59cecc98-b6e2-4db7-8665)",
                "updatedAt" => "2023-03-04T03:55:02.437Z",
                "workflowState" => "project",
                "name" => "Update Current Location",
                "createsNewFocus" => "false"
              }
            ]
          }
      }
    )
    CollectionSpace::Response.new(result)
  end

  it "finds an item by property" do
    subjects = [
      {
        args: ["abstract_common_list", "list_item", "name", "Reindex Full Text"],
        expected: "733c5a43-9094-4bcf-9d7a"
      },
      {
        args: ["abstract_common_list", "list_item", "name", "Merge Authority Items"],
        expected: "68f65633-1400-4be6-8db8"
      },
      {
        args: ["abstract_common_list", "list_item", "name", "Update Inventory Status"],
        expected: "c4ea120f-9e14-42a5-a40f"
      },
      {
        args: ["abstract_common_list", "list_item", "name", "Update Current Location"],
        expected: "59cecc98-b6e2-4db7-8665"
      }
    ]

    subjects.each do |subject|
      item = response.find(*subject[:args])
      expect(subject[:expected]).to eq(item["csid"])
    end
  end
end
