require 'core/repository/search/google_custom_search_engine/response_item_mapper'

module Core::Repository
  module Search
    class GoogleCustomSearchEngine < Core::Repository::Base
      class ResponseMapper
        def initialize(response)
          @body = response.body
        end

        def mapped_response
          {
            total_results: total_results,
            items: items,
            spelling_suggestion: spelling_sugestion
          }
        end

        private

        attr_reader :body

        def items
          body.fetch('items', []).map do |item_hash|
            ResponseItemMapper.new(item_hash).mapped_item_response
          end
        end

        def paging_metadata
          body['queries']['request'].first
        end

        def total_results
          paging_metadata['totalResults'].to_i
        end

        def offset
          paging_metadata['startIndex'].to_i - 1
        end

        def spelling_sugestion
          body.fetch('spelling', {}).fetch('correctedQuery', nil)
        end
      end
    end
  end
end
