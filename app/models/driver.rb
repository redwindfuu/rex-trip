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
require "bigdecimal"
require "rexy_admin"

class Driver < ApplicationRecord
  has_secure_password
  include RexyAdmin
  use_actions only: %i[create show index update toggle delete]

  set_query_actions action: :index,
                    fields: %i[id username email phone balance rating_avg is_available amount_invite status],
                    search_fields: %i[username email phone],
                    paginate: true

  set_query_actions action: :show,
                    fields: %i[id username email phone balance rating_avg is_available amount_invite status invite_code kyc_at kyc_status kyc_review kyc_by_id kyc_by_username],
                    after_query:  ->(record, params) {
                      record
                        .select("drivers.*, admins.username as kyc_by_username")
                        .left_outer_joins(:kyc_by)
                        .where(id: params[:id])
                    }

  set_action action: :create,
             params_checker: DriverValidator::CreateDriverValidator


  set_action action: :update,
              params_checker: DriverValidator::CreateDriverValidator,
              command: DriverCommands::DriverUpdateCommand




  enum status: { not_yet: 0, pending: 1, approved: 2, rejected: 3 }, _prefix: :kyc

  belongs_to :kyc_by, class_name: "Admin", optional: true

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :id_number, uniqueness: true, allow_nil: true

  before_create :preprocess_create

  private

  def preprocess_create
    self.invite_code = SecureRandom.hex(15)
    self.rating_avg = 3.0
    self.balance = 0
    self.is_available= false
    self.amount_invite = 0
  end
end
