class AdminPresenter 
  def initialize(admin)
    @admin = admin
  end

  def as_json
    {
      id: @admin.id,
      username: @admin.username,
      uuid: @admin.uuid,
      role: @admin.role
    }
  end
end
