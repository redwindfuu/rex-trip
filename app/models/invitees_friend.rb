class InviteesFriend < ApplicationRecord
  belongs_to :from, polymorphic: true # Could be Driver or Customer
  belongs_to :to, polymorphic: true   # Could be Driver or Customer
  # from is the inviter, to is the invitee
  # from is unique with
  validates :from_id, uniqueness: { scope: [:from_type] }
  
end
