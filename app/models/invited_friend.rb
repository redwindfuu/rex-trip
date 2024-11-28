class InvitedFriend < ApplicationRecord
  enum type: {
    CC: 0,
    DD: 1,
    CD: 2,
    DC: 3
  }

  def self.get_invitees(to_uuid)
    users = InvitedFriend.where(to_uuid: to_uuid)
    res = users.map do |user|
      if to_type(user.type.to_i)[1] == "C"
        customer = Customer.find_by(uuid: user.from_uuid).first
        return {
          id: customer.id,
          username: customer.username,
          full_name: customer.full_name,
          uuid: customer.uuid,
          type: "customer"
        }
      else
        driver = Driver.find_by(uuid: user.from_uuid).first
        return {
          id: driver.id,
          username: driver.username,
          full_name: driver.full_name,
          uuid: driver.uuid,
          type: "driver"
        }
      end
    end
  end

  private
  def to_type(type_int)
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

end
