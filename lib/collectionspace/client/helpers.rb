# frozen_string_literal: true

module CollectionSpace
  # Helper methods for client requests
  module Helpers
    # get ALL records at path by paging through record set
    def all(path, options = {})
      list_type, list_item = get_list_types(path)
      iterations = (count(path).to_f / config.page_size).ceil
      return [] unless iterations.positive?

      Enumerator::Lazy.new(0...iterations) do |yielder, i|
        response = request('GET', path, options.merge(query: { pgNum: i }))
        raise CollectionSpace::RequestError, response.result.body unless response.result.success?

        items_in_page = response.parsed[list_type].fetch('itemsInPage', 0).to_i
        list_items = items_in_page.positive? ? response.parsed[list_type][list_item] : []
        list_items = [list_items] if items_in_page == 1

        yielder << list_items.shift until list_items.empty?
      end
    end

    def count(path)
      list_type, = get_list_types(path)
      response   = request('GET', path, query: { pgNum: 0, pgSz: 1 })
      raise CollectionSpace::RequestError, response.result.body unless response.result.success?

      response.parsed[list_type]['totalItems'].to_i
    end

    # get the tenant domain from a system required top level authority (person)
    def domain
      path = 'personauthorities'
      response = request('GET', path, query: { pgNum: 0, pgSz: 1 })
      raise CollectionSpace::RequestError, response.result.body unless response.result.success?

      refname = response.parsed.dig(*get_list_types(path), 'refName')
      CollectionSpace::RefName.parse(refname)[:domain]
    end

    # find procedure or object by type and id
    # find authority/vocab term by type, subtype, and refname
    def find(type:, value:, subtype: nil, field: nil, schema: 'common', sort: nil)
      service = CollectionSpace::Service.get(type: type, subtype: subtype)
      field ||= service[:term] # this will be set if it is an authority or vocabulary, otherwise nil
      field ||= service[:identifier]
      sort ||= 'collectionspace_core:updatedAt DESC'
      search_args = CollectionSpace::Search.new.from_hash(
        path: service[:path],
        namespace: "#{service[:ns_prefix]}_#{schema}",
        field: field,
        expression: "= '#{value.gsub(/'/, '\\\\\'')}'"
      )
      search(search_args, sortBy: sort)
    end

    def find_relation(subject_csid:, object_csid:)
      get('relations', query: { 'sbj' => subject_csid, 'obj' => object_csid })
    end

    def get_list_types(path)
      {
        'accounts' => %w[accounts_common_list account_list_item],
        'relations' => %w[relations_common_list relation_list_item]
      }.fetch(path, %w[abstract_common_list list_item])
    end

    def reset_media_blob(id, url)
      raise CollectionSpace::ArgumentError, "Not a valid url #{url}" unless URI.parse(url).instance_of? URI::HTTPS

      response = find(type: 'media', value: id, field: 'identificationNumber')
      raise CollectionSpace::RequestError, response.result.body unless response.result.success?

      found = response.parsed
      total = found['abstract_common_list']['totalItems'].to_i
      raise CollectionSpace::NotFoundError, "Media #{id} not found" if total.zero?
      raise CollectionSpace::DuplicateIdFound, "Found multiple media records for #{id}" unless total == 1

      media_uri = found['abstract_common_list']['list_item']['uri']
      blob_csid = found['abstract_common_list']['list_item']['blobCsid']

      delete("/blobs/#{blob_csid}") if blob_csid

      # TODO: media_common can be empty?
      media_payload = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <document name="media">
        <ns2:media_common xmlns:ns2="http://collectionspace.org/services/media" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <identificationNumber>#{id}</identificationNumber>
        </ns2:media_common>
      </document>
      XML

      put(media_uri, media_payload.lstrip, query: { 'blobUri' => url })
    end

    def search(query, params = {})
      options = prepare_query(query, params)
      request 'GET', query.path, options
    end

    def service(type:, subtype: '')
      CollectionSpace::Service.get(type: type, subtype: subtype)
    end

    private

    def prepare_query(query, params = {})
      query_string = "#{query.namespace}:#{query.field} #{query.expression}"
      { query: { as: query_string }.merge(params) }
    end
  end
end
