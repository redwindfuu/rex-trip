# frozen_string_literal: true

module SystemCommands
  class EnterCodeCommand
    prepend SimpleCommand
    attr_accessor :code, :from_uuid, :type

    def initialize( from_uuid, code, type)
      @from_uuid = from_uuid
      @code = code
      @type = type
    end

    # CC : Customer to Customer
    # CD : Customer to Driver
    # DC : Driver to Customer
    # DD : Driver to Driver
    def call
      cmd = SystemValidator::EnterCodeValidator.call(params: {
        code: code,
        from_uuid: from_uuid,
        type: type
      })

      if cmd.failure?
        errors.add(:error, cmd.errors)
        return
      end

      is_invited = InvitedFriend.find_by(from_uuid: from_uuid).first
      if is_invited
        errors.add(:error, "You have already invited by another user")
        return
      end

      inviter = (type[0] == "C") ?
                  Customer.find_by(amount_invite: code).first :
                  Driver.find_by(amount_invite: code).first

      if inviter.nil? || inviter.uuid == from_uuid
        errors.add(:error, "Code is invalid")
        return
      end

      InvitedFriend.create!(from_uuid: from_uuid, to_uuid: inviter.uuid, type: InvitedFriend.types[type.to_sym])
    end
  end
end
