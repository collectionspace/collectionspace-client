module CollectionSpace

  module Helpers

    # get ALL records at path by paging through record set
    # can pass block to act on each page of results
    def all(path, options = {}, &block)
      all = []
      result = request('GET', path, options)
      raise RequestError.new result.status if result.status_code != 200 or result.parsed['abstract_common_list'].nil?

      total = result.parsed['abstract_common_list']['totalItems'].to_i
      items = result.parsed['abstract_common_list']['itemsInPage'].to_i
      return all if total == 0

      pages = (total / config.page_size) + 1
      (0 .. pages - 1).each do |i|
        options[:query][:pgNum] = i
        result     = request('GET', path, options)
        raise RequestError.new result.status if result.status_code != 200
        list_items = result.parsed['abstract_common_list']['list_item']
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
      query_string = "#{query.type}:#{query.field} #{query.expression}"
      options = options.merge({ query: { as: query_string } })
      request "GET", query.path, options
    end

  end

end