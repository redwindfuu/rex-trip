# == Schema Information
#
# Table name: invitees_friends
#
#  id              :bigint           not null, primary key
#  inviter_type    :string           not null
#  inviter_id      :bigint           not null
#  inviteable_type :string           not null
#  inviteable_id   :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class InviteesFriend < ApplicationRecord
  belongs_to :inviter, polymorphic: true # Could be Driver or Customer
  belongs_to :inviteable, polymorphic: true   # Could be Driver or Customer
 
  belongs_to :driver_inviteable, -> { where(
    invitees_friends: { inviteable_type: "Driver" }
  ) }, class_name: "Driver", foreign_key: "inviteable_id", optional: true

  belongs_to :customer_inviteable, -> { where(
    invitees_friends: { inviteable_type: "Customer" }
  ) }, class_name: "Customer", foreign_key: "inviteable_id", optional: true

  belongs_to :driver_inviter, -> { where(
    invitees_friends: { inviter_type: "Driver" }
  ) }, class_name: "Driver", foreign_key: "inviter_id", optional: true

  belongs_to :customer_inviter, -> { where(
    invitees_friends: { inviter_type: "Customer" }
  ) }, class_name: "Customer", foreign_key: "inviter_id", optional: true

  # inviter "người mời", inviteable "người được mời"
  validates :inviteable_id, uniqueness: { scope: [ :inviteable_type ] }
end
