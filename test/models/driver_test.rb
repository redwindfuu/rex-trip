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
require "test_helper"

class DriverTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
