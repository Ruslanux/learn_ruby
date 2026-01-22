# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 50
  MAX_PER_PAGE = 100

  included do
    helper_method :pagination_meta if respond_to?(:helper_method)
  end

  # Paginate a collection using page-based pagination
  # Returns the paginated collection and sets instance variables
  #
  # @param collection [ActiveRecord::Relation] the collection to paginate
  # @param per_page [Integer] number of items per page (default: 50)
  # @return [ActiveRecord::Relation] paginated collection
  def paginate(collection, per_page: DEFAULT_PER_PAGE)
    per_page = [per_page.to_i, MAX_PER_PAGE].min
    per_page = DEFAULT_PER_PAGE if per_page <= 0

    @total_count = collection.count
    @page = [(params[:page] || 1).to_i, 1].max
    @per_page = per_page
    @total_pages = (@total_count.to_f / per_page).ceil
    @total_pages = 1 if @total_pages.zero?

    collection.offset((@page - 1) * per_page).limit(per_page)
  end

  # Paginate using limit/offset parameters (for API)
  # Returns the paginated collection
  #
  # @param collection [ActiveRecord::Relation] the collection to paginate
  # @param default_limit [Integer] default limit if not specified (default: 50)
  # @return [ActiveRecord::Relation] paginated collection
  def paginate_with_offset(collection, default_limit: DEFAULT_PER_PAGE)
    limit = [(params[:limit] || default_limit).to_i, MAX_PER_PAGE].min
    limit = default_limit if limit <= 0

    offset = [params[:offset].to_i, 0].max

    @limit = limit
    @offset = offset
    @total_count = collection.count

    collection.offset(offset).limit(limit)
  end

  # Returns pagination metadata for API responses
  def pagination_meta
    if defined?(@limit) && defined?(@offset)
      {
        limit: @limit,
        offset: @offset,
        total_count: @total_count,
        has_more: @offset + @limit < @total_count
      }
    else
      {
        page: @page,
        per_page: @per_page,
        total_pages: @total_pages,
        total_count: @total_count
      }
    end
  end
end
