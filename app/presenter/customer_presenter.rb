class CustomerPresenter < BasePresenter
  def id
    @model.id
  end

  def uuid
    @model.uuid
  end

  def username
    @model.username
  end

  def email
    @model.email
  end

  def full_name
    @model.full_name
  end

  def phone
    @model.phone
  end

  def avatar_link
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    @model.avatar_link.nil? ? nil : "#{domain}#{@model.avatar_link}"
  end

  def created_at
    @model.created_at
  end

  def invite_code
    @model.invite_code
  end

  def invite_amount
    @model.amount_invite
  end

  def as_json
    {
      id:,
      uuid:,
      username:,
      email:,
      full_name:,
      phone:,
      avatar_link:,
      created_at:,
      invite_code:,
      invite_amount:
    }
  end
end
