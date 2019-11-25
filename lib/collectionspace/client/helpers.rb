module CollectionSpace
  # Helper methods for client requests
  module Helpers
    # get ALL records at path by paging through record set
    def all(path, options = {})
      list_type, list_item = get_list_types(path)
      Enumerator.new do |yielder|
        page = 0
        loop do
          response = request('GET', path, options.merge(query: { pgNum: page }))
          unless response.result.success?
            raise CollectionSpace::RequestError, response.result.body
          end

          items = response.parsed[list_type].fetch('itemsInPage', 0).to_i
          raise StopIteration if items.zero?

          list_items = response.parsed[list_type][list_item]
          list_items = [list_items] if items == 1
          list_items.each { |item| yielder << item }
          page += 1
        end
      end.lazy
    end

    def count(path)
      list_type, = get_list_types(path)
      response   = request('GET', path, query: { pgSz: 1 })
      response.parsed[list_type]['totalItems'].to_i if response.result.success?
    end

    def get_list_types(path)
      if path == 'relations'
        %w[relations_common_list relation_list_item]
      else
        %w[abstract_common_list list_item]
      end
    end

    def prepare_query(query, options = {})
      query_string = "#{query.type}:#{query.field} #{query.expression}"
      options.merge(query: { as: query_string })
    end

    def search(query, options = {})
      options = prepare_query(query, options)
      request 'GET', query.path, options
    end
  end
end
