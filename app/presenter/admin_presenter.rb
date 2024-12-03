class AdminPresenter < BasePresenter
  
  def as_json
    {
      id: @model.id,
      username: @model.username,
      uuid: @model.uuid,
      role: @model.role
    }
  end
end
