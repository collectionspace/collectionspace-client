# frozen_string_literal: true

module CollectionSpace
  # Helper methods for client requests
  module Helpers
    # add / update batch job
    def add_batch_job(name, template, data = {}, params = {pgSz: 100})
      payload = Template.process(template, data)
      response = get("batch", {query: params})
      create_or_update(response, "batch", "name", name, payload)
    end

    # add / update batches and data updates
    def add_batch(data = {}, params = {pgSz: 100})
      payload = Template.process("batch", data)
      response = get("batch", {query: params})
      create_or_update(response, "batch", "name", data[:name], payload)
    end

    # add / update reports
    def add_report(data = {}, params = {pgSz: 100})
      payload = Template.process("report", data)
      response = get("reports", {query: params})
      create_or_update(response, "reports", "name", data[:name], payload)
    end

    # returns Array of authority doctypes for use in setting up batches
    def authority_doctypes
      response = get("/servicegroups/authority")
      unless response.result.success?
        raise CollectionSpace::RequestError, response.result.body
      end

      result = response.result.parsed_response
      result.dig("document", "servicegroups_common", "hasDocTypes", "hasDocType")
    end

    # get ALL records at path by paging through record set
    def all(path, options = {})
      list_type, list_item = get_list_types(path)
      iterations = (count(path).to_f / config.page_size).ceil
      return [] unless iterations.positive?

      Enumerator::Lazy.new(0...iterations) do |yielder, i|
        response = request("GET", path, options.merge(query: {pgNum: i}))
        raise CollectionSpace::RequestError, response.result.body unless response.result.success?

        items_in_page = response.parsed[list_type].fetch("itemsInPage", 0).to_i
        list_items = items_in_page.positive? ? response.parsed[list_type][list_item] : []
        list_items = [list_items] if items_in_page == 1

        yielder << list_items.shift until list_items.empty?
      end
    end

    def count(path)
      list_type, = get_list_types(path)
      response = request("GET", path, query: {pgNum: 0, pgSz: 1})
      raise CollectionSpace::RequestError, response.result.body unless response.result.success?

      response.parsed[list_type]["totalItems"].to_i
    end

    # get the tenant domain from a system required top level authority (person)
    def domain
      path = "personauthorities"
      response = request("GET", path, query: {pgNum: 0, pgSz: 1})
      raise CollectionSpace::RequestError, response.result.body unless response.result.success?

      refname = response.parsed.dig(*get_list_types(path), "refName")
      CollectionSpace::RefName.parse(refname)[:domain]
    end

    # find procedure or object by type and id
    # find authority/vocab term by type, subtype, and refname
    def find(type:, value:, subtype: nil, field: nil, schema: "common", sort: nil, operator: "=")
      service = CollectionSpace::Service.get(type: type, subtype: subtype)
      field ||= service[:term] # this will be set if it is an authority or vocabulary, otherwise nil
      field ||= service[:identifier]
      search_args = CollectionSpace::Search.new.from_hash(
        path: service[:path],
        namespace: "#{service[:ns_prefix]}_#{schema}",
        field: field,
        expression: "#{operator} '#{value.gsub(/'/, "\\\\'")}'"
      )
      search(search_args, sortBy: CollectionSpace::Search::DEFAULT_SORT)
    end
    # rubocop:enable Metrics/ParameterLists

    # @param subject_csid [String] to be searched as `sbj` value
    # @param object_csid [String] to be searched as `obj` value
    # @param rel_type [String<'affects', 'hasBroader'>, nil] to be searched as `prd` value
    def find_relation(subject_csid:, object_csid:, rel_type: nil)
      if rel_type
        get("relations", query: {"sbj" => subject_csid, "obj" => object_csid, "prd" => rel_type})
      else
        warn(
          "No rel_type specified, so multiple types of relations between #{subject_csid} and #{object_csid} may be returned",
          uplevel: 1
        )
        get("relations", query: {"sbj" => subject_csid, "obj" => object_csid})
      end
    end

    def get_list_types(path)
      {
        "accounts" => %w[accounts_common_list account_list_item],
        "relations" => %w[relations_common_list relation_list_item]
      }.fetch(path, %w[abstract_common_list list_item])
    end

    def reindex_full_text(doctype, csids = [])
      if csids.any?
        run_job(
          "Reindex Full Text", :reindex_full_text, :reindex_by_csids, {doctype: doctype, csids: csids}
        )
      else
        run_job(
          "Reindex Full Text", :reindex_full_text, :reindex_by_doctype, {doctype: doctype}
        )
      end
    end

    # @param id [String] media record's identificationNumber value
    # @param url [String] blobUri value
    # @param verbose [Boolean] whether to put brief report of outcome to STDOUT
    # @param ensure_safe_url [Boolean] set to false if using FILE URIs or
    #   other non-HTTPS URIs
    # @param delete_existing_blob [Boolean] set to false if you have already
    #   manually deleted blobs
    def reset_media_blob(id:, url:, verbose: false,
      ensure_safe_url: true,
      delete_existing_blob: true)
      if ensure_safe_url
        unless URI.parse(url).instance_of? URI::HTTPS
          raise CollectionSpace::ArgumentError, "Not a valid url #{url}"
        end
      end

      response = find(type: "media", value: id, field: "identificationNumber")
      unless response.result.success?
        if verbose
          puts "#{id}\tfailure\tAPI request error: #{response.result.body}"
        else
          raise CollectionSpace::RequestError, response.result.body
        end
      end

      found = response.parsed
      total = found["abstract_common_list"]["totalItems"].to_i

      if total.zero?
        msg = "Media #{id} not found"
        if verbose
          puts "#{id}\tfailure\t#{msg}"
        else
          raise CollectionSpace::NotFoundError, msg
        end
      elsif total > 1
        msg = "Found multiple media records for #{id}"
        if verbose
          puts "#{id}\tfailure\t#{msg}"
        else
          raise CollectionSpace::DuplicateIdFound, msg
        end
      end

      media_uri = found["abstract_common_list"]["list_item"]["uri"]

      if delete_existing_blob
        blob_csid = found["abstract_common_list"]["list_item"]["blobCsid"]
        delete("/blobs/#{blob_csid}") if blob_csid
      end

      payload = Template.process(:reset_media_blob, {id: id})
      response = put(media_uri, payload, query: {"blobUri" => url})
      if verbose
        if response.result.success?
          puts "#{id}\tsuccess\t"
        else
          puts "#{id}\tfailure\t#{response.parsed}"
        end
      else
        response
      end
    end

    def run_job(name, template, invoke_template, data = {})
      payload = Template.process(invoke_template, data)
      job = add_batch_job(name, template)
      path = job.parsed["document"]["collectionspace_core"]["uri"]
      post(path, payload)
    end

    def search(query, params = {})
      options = prepare_query(query, params)
      request "GET", query.path, options
    end

    def keyword_search(type:, value:, subtype: nil, sort: nil)
      service = CollectionSpace::Service.get(type: type, subtype: subtype)
      options = prepare_keyword_query(value, {sortBy: CollectionSpace::Search::DEFAULT_SORT})
      request "GET", service[:path], options
    end

    def service(type:, subtype: "")
      CollectionSpace::Service.get(type: type, subtype: subtype)
    end

    private

    def create_or_update(response, path, property, value, payload)
      list_type, item_type = get_list_types(path)
      item = response.find(list_type, item_type, property, value)
      path = item ? "#{path}/#{item["csid"]}" : path
      item ? put(path, payload) : post(path, payload)
    end

    def prepare_query(query, params = {})
      query_string = "#{query.namespace}:#{query.field} #{query.expression}"
      {query: {as: query_string}.merge(params)}
    end

    def prepare_keyword_query(query, sort = {})
      query_string = query.downcase.tr(" ", "+")
      {query: {kw: query_string}.merge(sort)}
    end
  end
end
