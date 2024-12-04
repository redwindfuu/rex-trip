# == Schema Information
#
# Table name: invited_friends
#
#  id          :bigint           not null, primary key
#  to_uuid     :uuid             not null
#  from_uuid   :uuid             not null
#  invite_code :string           not null
#  invite_type :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class InvitedFriend < ApplicationRecord
  belongs_to :inviter, polymorphic: true

  enum invite_type: {
    CC: 0,
    DD: 1,
    CD: 2,
    DC: 3
  }

  


  def self.convert_type(type_int)
    case type_int
    when 0
      "CC"
    when 1
      "DD"
    when 2
      "CD"
    when 3
      "DC"
    else
      ""
    end
  end

  def self.get_invitees(to_uuid)
    users = InvitedFriend.where(to_uuid: to_uuid)
    res = users.map do |user|
      if user.invite_type[1] == "C"
        customer = Customer.find_by(uuid: user.from_uuid)
         {
          id: customer[:id],
          username: customer[:username],
          full_name: customer[:full_name],
          uuid: customer[:uuid],
          invite_type: "customer"
        }
      else
        driver = Driver.find_by(uuid: user.from_uuid)
         {
          id: driver[:id],
          username: driver[:username],
          full_name: driver[:full_name],
          uuid: driver[:uuid],
          invite_type: "driver"
        }
      end
    end
    res
  end


  private
end
