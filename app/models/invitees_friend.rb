# == Schema Information
#
# Table name: invitees_friends
#
#  id         :bigint           not null, primary key
#  from_type  :string           not null
#  from_id    :bigint           not null
#  to_type    :string           not null
#  to_id      :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class InviteesFriend < ApplicationRecord
  belongs_to :from, polymorphic: true # Could be Driver or Customer
  belongs_to :to, polymorphic: true   # Could be Driver or Customer
  # from is the inviter, to is the invitee
  # from is unique with
  validates :from_id, uniqueness: { scope: [:from_type] }
  
end
