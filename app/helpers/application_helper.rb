module ApplicationHelper
  def present(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield presenter if block_given?
    # check is the presenter is array or not
    binding.pry
    presenter.is_a?(Array) ? presenter.map(&:as_json) : presenter.as_json
    
  end
end
