class DriverSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :phone, :avatar_link, :username, :invite_code, :invite_amount, :kyc_status, :is_available, :rating_avg

  attribute :detail_option,
            if: -> { show_type?('detail') }


  def avatar_link
    domain = ENV.fetch('DOMAIN', 'http://localhost:8000')
    object.avatar_link.nil? ? nil : "#{domain}#{object.avatar_link}"
  end

  def invite_amount
    object.amount_invite
  end

  def kyc_status
    object.status
  end

  def show_type?(type)
    @instance_options[:show_more_info] == type
  end

  def detail_option
    kyc_by_admin = Admin.find(object.kyc_by_id) if object.kyc_by_id
    domain = ENV.fetch('DOMAIN', 'http://localhost:8000')
    {
      kyc_by: kyc_by_admin&.username,
      kyc_review: object.kyc_review,
      kyc_at: object.kyc_at,
      id_number: object.id_number,
      front_side_link: domain + object.front_side_link,
      backside_link: domain + object.backside_link,
      balance: object.balance
    }
  end


end