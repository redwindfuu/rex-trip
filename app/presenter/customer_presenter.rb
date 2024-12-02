class CustomerPresenter
  def initialize(customer)
    @customer = customer
  end

  def id
    @customer.id
  end

  def uuid
    @customer.uuid
  end

  def username
    @customer.username
  end

  def email
    @customer.email
  end

  def full_name
    @customer.full_name
  end

  def phone
    @customer.phone
  end

  def avatar_link
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    @customer.avatar_link.nil? ? nil : "#{domain}#{@customer.avatar_link}"
  end

  def created_at
    @customer.created_at
  end

  def invite_code
    @customer.invite_code
  end

  def invite_amount
    @customer.amount_invite
  end
end
