class DriverPresenter
  
  def initialize(driver, show_more_info: nil)
    @driver = driver
    @show_more_info = show_more_info
  end

  def id
    @driver.id
  end

  def uuid
    @driver.uuid
  end

  def email
    @driver.email
  end

  def full_name
    @driver.full_name
  end

  def phone
    @driver.phone
  end

  def avatar_link
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    @driver.avatar_link.nil? ? nil : "#{domain}#{@driver.avatar_link}"
  end

  def username
    @driver.username
  end

  def invite_code
    @driver.invite_code
  end

  def kyc_status
    @driver.status
  end

  def is_available
    @driver.is_available
  end

  def rating_avg
    @driver.rating_avg
  end

  def detail_option
    return unless show_type?("detail")

    kyc_by_admin = Admin.find(@driver.kyc_by_id) if @driver.kyc_by_id
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    back_side_link = @driver.backside_link.nil? ? nil : "#{domain}#{@driver.backside_link}"
    front_side_link = @driver.front_side_link.nil? ? nil : "#{domain}#{@driver.front_side_link}"

    {
      kyc_by: kyc_by_admin&.username,
      kyc_review: @driver.kyc_review,
      kyc_at: @driver.kyc_at,
      id_number: @driver.id_number,
      front_side_link: front_side_link,
      backside_link: back_side_link,
      balance: @driver.balance,
      invite_amount: @driver.amount_invite
    }
  end

  def as_json (options = {})
    res = {
      id: id,
      uuid: uuid,
      email: email,
      full_name: full_name,
      phone: phone,
      avatar_link: avatar_link,
      username: username,
      invite_code: invite_code,
      kyc_status: kyc_status,
      is_available: is_available,
      rating_avg: rating_avg
    }

    res.merge!({detail: detail_option}) if show_type?("detail")

    res
  end

  private

  def show_type?(type)
    @show_more_info == type
  end
end
