class CollectionPresenter
  def initialize(collection, presenter_class)
    @collection = collection
    @presenter_class = presenter_class
  end

  def as_json(_options = {})
    @collection.map { |item| @presenter_class.new(item).as_json(_options) }
  end
end