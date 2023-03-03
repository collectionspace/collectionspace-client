# frozen_string_literal: true

module CollectionSpace
  # CollectionSpace batch
  class Batch
    def self.all
      [
        {
          name: "Update Current Location",
          notes: "Recompute the current location of Object records, based on the " \
            "related Location/Movement/Inventory records. Runs on a single record " \
            "or all records.",
          doctype: %w[CollectionObject],
          supports_single_doc: "true",
          supports_doc_list: "false",
          supports_group: "false",
          supports_no_context: "true",
          creates_new_focus: "false",
          classname:
          "org.collectionspace.services.batch.nuxeo.UpdateObjectLocationBatchJob"
        },
        {
          name: "Update Inventory Status",
          notes: "Set the inventory status of selected Object records. Runs on a " \
            "record list only.",
          doctype: %w[CollectionObject],
          supports_single_doc: "false",
          supports_doc_list: "true",
          supports_group: "false",
          supports_no_context: "false",
          creates_new_focus: "false",
          classname:
          "org.collectionspace.services.batch.nuxeo.UpdateInventoryStatusBatchJob"
        },
        {
          name: "Merge Authority Items",
          notes: "Merge an authority item into a target, and update all " \
            "referencing records. Runs on a single record only.",
          doctype: %w[],
          supports_single_doc: "true",
          supports_doc_list: "false",
          supports_group: "false",
          supports_no_context: "false",
          creates_new_focus: "false",
          classname:
          "org.collectionspace.services.batch.nuxeo.MergeAuthorityItemsBatchJob"
        }
      ]
    end

    def self.find(key, value)
      all.find { |batch| batch[key] == value }
    end
  end
end
