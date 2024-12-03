class BasePresenter < SimpleDelegator
  attr_reader :model, :view
  def initialize(model, view = nil)
    @model, @view = model, view
    super @model
  end

  def as_json
    raise NotImplementedError
  end
end
