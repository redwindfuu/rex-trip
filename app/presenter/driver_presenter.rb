class DriverPresenter < BasePresenter
  
  def initialize(driver, show_more_info: nil)
    @show_more_info = show_more_info
    super(driver)
  end

  def id
    @model.id
  end

  def uuid
    @model.uuid
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

  def username
    @model.username
  end

  def invite_code
    @model.invite_code
  end

  def kyc_status
    @model.status
  end

  def is_available
    @model.is_available
  end

  def rating_avg
    @model.rating_avg
  end

  def detail_option
    return unless show_type?("detail")

    kyc_by_admin = Admin.find(@model.kyc_by_id) if @model.kyc_by_id
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    back_side_link = @model.backside_link.nil? ? nil : "#{domain}#{@model.backside_link}"
    front_side_link = @model.front_side_link.nil? ? nil : "#{domain}#{@model.front_side_link}"

    {
      kyc_by: kyc_by_admin&.username,
      kyc_review: @model.kyc_review,
      kyc_at: @model.kyc_at,
      id_number: @model.id_number,
      front_side_link: front_side_link,
      backside_link: back_side_link,
      balance: @model.balance,
      invite_amount: @model.amount_invite
    }
  end

  def as_json (options = {})
    res = {
      id:,
      uuid:,
      email:,
      full_name:,
      phone:,
      avatar_link:,
      username:,
      invite_code:,
      kyc_status:,
      is_available:,
      rating_avg: 
    }

    res.merge!({ detail: detail_option }) if show_type?("detail")

    res
  end

  private

  def show_type?(type)
    @show_more_info == type
  end
end
