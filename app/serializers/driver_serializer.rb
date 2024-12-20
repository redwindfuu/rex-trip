# == Schema Information
#
# Table name: drivers
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  full_name       :string
#  email           :string
#  phone           :string
#  avatar_link     :string
#  front_side_link :string
#  backside_link   :string
#  id_number       :string
#  username        :string
#  password_digest :string
#  balance         :decimal(, )
#  is_available    :boolean
#  rating_avg      :float
#  amount_invite   :integer
#  invite_code     :string
#  status          :integer          default("not_yet")
#  kyc_at          :datetime
#  kyc_by_id       :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  kyc_review      :text
#
class DriverSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :full_name, :phone, :avatar_link, :username, :invite_code, :kyc_status, :is_available, :rating_avg

  attribute :detail_option,
            if: -> { show_type?("detail") }


  def avatar_link
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    # object.avatar_link.nil? ? nil : "#{domain}#{object.avatar_link}"
    object.avatar_link.nil? ? nil : object.avatar_link
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
    domain = ENV.fetch("DOMAIN", "http://localhost:8000")
    back_side_link = object.backside_link.nil? ? nil : domain + object.backside_link
    front_side_link = object.front_side_link.nil? ? nil : domain + object.front_side_link
    {
      kyc_by: kyc_by_admin&.username || nil,
      kyc_review: object.kyc_review,
      kyc_at: object.kyc_at,
      id_number: object.id_number,
      front_side_link: front_side_link,
      backside_link: back_side_link,
      balance: object.balance,
      invite_amount: object.amount_invite
    }
  end
end
