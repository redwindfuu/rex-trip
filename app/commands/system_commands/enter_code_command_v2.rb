module SystemCommands
  class EnterCodeCommandV2
    prepend SimpleCommand

    attr_accessor :code, :from_uuid, :begin_type

    def initialize(from_uuid, code, begin_type)
      @code = code
      @from_uuid = from_uuid
      @begin_type = begin_type
    end
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

      _, inviter = get_type_from_code(begin_type, code)

      invitees = get_invitees_from_uuid(from_uuid)

      is_invited = InvitedFriend.find_by(from: invitees)

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
        InvitedFriend.create!(from: invitees, to: inviter)
      end
    end

    def get_type_from_code(type, code)
      customer = Customer.find_by(invite_code: code)

      return "C" + type, customer if customer

      driver = Driver.find_by(invite_code: code)

      return [ "D" + type, driver ] if driver

      [ nil, nil ]
    end

    def get_invitees_from_uuid(uuid)
      user = nil 

      user = Customer.find_by(uuid: uuid) if user.nil?
      return user if user
        
      user = Driver.find_by(uuid: uuid) if user.nil?
      return user if user
      nil    
    end
  end
end
