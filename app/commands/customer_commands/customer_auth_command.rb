# frozen_string_literal: true

module CustomerCommands
  class CustomerAuthCommand
    prepend SimpleCommand

    def initialize(username = nil, password = nil)
      @username = username
      @password = password
    end

    def call
      raise Errors::BadRequest unless @username && @password

      if (user = Customer.find_by(username: @username)&.authenticate(@password))
        user_data = {
          user: {
            id: user[:id],
            username: user[:username],
            uuid: user[:uuid]
          },
          type: "customer"
        }
        access_token = Auth.issue(user_data)
        { access_token: access_token, user: CustomerSerializer.new(user) }
      else
        errors.add(:base, "Invalid username or password")
      end
    end
  end
end
