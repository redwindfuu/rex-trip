# frozen_string_literal: true

module SystemCommands
  class EnterCodeCommand
    prepend SimpleCommand
    attr_accessor :code, :from_uuid, :begin_type

    def initialize(from_uuid, code, begin_type)
      @from_uuid = from_uuid
      @code = code
      @begin_type = begin_type
    end

    # CC : Customer to Customer
    # CD : Customer to Driver
    # DC : Driver to Customer
    # DD : Driver to Driver
    def call
      cmd = SystemValidator::EnterCodeValidator.call(params: {
        code: code,
        from_uuid: from_uuid,
        type: begin_type
      })

      if cmd.failure?
        errors.add(:error, cmd.errors)
        return
      end
      type , inviter = get_type_from_code(begin_type, code)

      is_invited = InvitedFriend.find_by(from_uuid: from_uuid)
      if is_invited
        errors.add(:error, "You have already invited by another user")
        return
      end

      if inviter.nil? || inviter[:uuid] == from_uuid
        errors.add(:error, "Code is invalid")
        return
      end
      InvitedFriend.transaction do
        inviter.increment!(:amount_invite)
        InvitedFriend.create!(from_uuid: from_uuid, to_uuid: inviter.uuid, invite_type: InvitedFriend.invite_types[type.to_sym], invite_code: code)
      end
    end

    def get_type_from_code(type, code)
      customer = Customer.find_by(invite_code: code)

      return "C" + type , customer if customer

      driver = Driver.find_by(invite_code: code)

      return ["D" + type, driver] if driver

      [nil, nil]
    end

  end
end

