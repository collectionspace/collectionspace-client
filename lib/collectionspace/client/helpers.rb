module CollectionSpace

  # http://www.garrettqmartin.com/2015/02/03/finding-deeply-nested-hash-keys/
  module DeepFind
    def deep_find(obj, key, nested_key = nil)
      return obj[key] if obj.respond_to?(:key?) && obj.key?(key)
      if obj.is_a? Enumerable
        found = nil
        obj.find { |*a| found = deep_find(a.last, key) }
        if nested_key
          deep_find(found, nested_key)
        else
          found
        end
      end
    end
  end

  module Helpers

    # get ALL records at path by paging through record set
    # can pass block to act on each page of results
    def all(path, options = {}, &block)
      all = []
      list_type, list_item = get_list_types(path)

      result = request('GET', path, options)
      raise RequestError.new result.status if result.status_code != 200 or result.parsed[list_type].nil?

      total = result.parsed[list_type]['totalItems'].to_i
      items = result.parsed[list_type]['itemsInPage'].to_i
      return all if total == 0

      pages = (total / config.page_size) + 1
      (0 .. pages - 1).each do |i|
        options[:query][:pgNum] = i
        result     = request('GET', path, options)
        raise RequestError.new result.status if result.status_code != 200
        list_items = result.parsed[list_type][list_item]
        list_items = [ list_items ] if items == 1
        list_items.each { |item| yield item if block_given? }
        all.concat list_items
      end
      all
    end

    def count(path)
      # make sure path is only 1 level deep?
      count  = nil
      result = request('GET', path, { query: { pgSz: 1 } })
      count  = result.parsed['abstract_common_list']['totalItems'].to_i if result.status_code == 200
      count
    end

    # create blob record by external url
    def post_blob_url(url)
      raise ArgumentError.new("Invalid blob URL #{url}") unless URI.parse(url).scheme =~ /^https?/
      request 'POST', "blobs", {
        query: { "blobUri" => url },
      }
    end

    def post_relationship(type_a, csid_a, type_b, csid_b)
      # requires an erb template
      # request 'POST', "relations", { body: payload }
      # flip for reciprocal relationship
      # request 'POST', "relations", { body: payload }
    end

    def search(query, options = {})
      options = prepare_query(query, options)
      request "GET", query.path, options
    end

    def search_all(query, options = {}, &block)
      options = prepare_query(query, options)
      all query.path, options, &block
    end

    def strip_refname(refname)
      refname.match(/('.*')/)[0].delete("'")
    end

    # parsed record and map to get restructured object
    def to_object(record, attribute_map)
      attributes = {}
      attribute_map.each do |map|
        if map["with"]
          as = deep_find(record, map["key"], map["nested_key"])
          values = []
          if as.is_a? Array
            values = as.map { |a| strip_refname( deep_find(a, map["with"]) ) }
          elsif as.is_a? Hash and as[ map["with"] ]
            values = as[ map["with"] ].is_a?(Array) ? as[ map["with"] ].map { |a| strip_refname(a) } : [ strip_refname(as[ map["with"] ]) ]
          end
          attributes[map["field"]] = values
        else
          attributes[map["field"]] = deep_find(record, map["key"], map["nested_key"])
        end
      end
      attributes
    end

    private

    def get_list_types(path)
      list_type, list_item = nil
      if path == 'relations'
        list_type = 'relations_common_list'
        list_item = 'relation_list_item'
      else
        list_type = 'abstract_common_list'
        list_item = 'list_item'
      end
      return list_type, list_item
    end

    def prepare_query(query, options = {})
      query_string = "#{query.type}:#{query.field} #{query.expression}"
      options      = options.merge({ query: { as: query_string } })
      options
    end

  end

end