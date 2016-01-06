$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'collectionspace/client'

# CREATE CLIENT WITH DEFAULT (DEMO) CONFIGURATION -- BE NICE!!!
client = CollectionSpace::Client.new

# EXAMPLE NESTED ATTRIBUTE SEARCH
search_args = {
  path: "collectionobjects",
  type: "collectionobjects_common",
  field: 'titleGroupList/*1/title',
  expression: "ILIKE '%blue%'",
}

query = CollectionSpace::Search.new.from_hash search_args
ap client.search(query).parsed

# SEARCH AND REFORMAT RESULTS

# assume retrieved for collectionobject i.e.: AttributeMap.where(type: 'collectionobject')
attribute_map = [
  { field: 'title', key: 'collectionobjects_common', nested_key: 'title', with: nil },
  { field: 'title_type', key: 'collectionobjects_common', nested_key: 'titleType', with: nil },
  { field: 'display_date', key: 'collectionobjects_common', nested_key: 'dateDisplayDate', with: nil },
  { field: 'object_production_person_group', key: 'collectionobjects_common', nested_key: 'objectProductionPersonGroup', with: 'objectProductionPerson' },
  { field: 'content_persons', key: 'collectionobjects_common', nested_key: 'contentPersons', with: 'contentPerson' },
  { field: 'responsible_department', key: 'collectionobjects_common', nested_key: 'responsibleDepartment', with: nil },
  { field: 'created_by', key: 'collectionspace_core', nested_key: 'createdBy', with: nil },
  { field: 'created_at', key: 'collectionspace_core', nested_key: 'createdAt', with: nil },
  { field: 'updated_at', key: 'collectionspace_core', nested_key: 'updatedAt', with: nil },
]

search_args = {
  path: "collectionobjects",
  type: "collectionspace_core",
  field: 'updatedAt',
  expression: ">= TIMESTAMP '2015-12-17T00:00:00'",
}

query = CollectionSpace::Search.new.from_hash search_args

result = client.search(query)
if result.status_code == 200
  data = result.parsed["abstract_common_list"]["list_item"]
  data.each do |item|
    record = client.get(item["uri"]).parsed

    attributes = {}
    attribute_map.each do |map|
      if map[:with]
        as = client.deep_find(record, map[:key], map[:nested_key])
        values = []
        if as.is_a? Array
          values = as.map { |a| client.strip_refname( client.deep_find(a, map[:with]) ) }
        elsif as.is_a? Hash and as[ map[:with] ]
          values = as[ map[:with] ].is_a?(Array) ? as[ map[:with] ].map { |a| client.strip_refname(a) } : [ client.strip_refname(as[ map[:with] ]) ]
        end
        attributes[map[:field]] = values
      else
        attributes[map[:field]] = client.deep_find(record, map[:key], map[:nested_key])
      end
    end
    # PRINT REFORMATTED RESULTS
    ap attributes
  end
end