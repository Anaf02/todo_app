class PaginationService
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def initialize(collection, page: nil, per_page: nil)
    @collection = collection
    @page = (page || DEFAULT_PAGE).to_i
    @per_page = (per_page || DEFAULT_PER_PAGE).to_i
  end

  def call
    @collection.page(@page).per(@per_page)
  end
end
