# frozen_string_literal: true

module DriverCommands
  class DriverAuthCommand

    prepend SimpleCommand

    def initialize(username = nil, password = nil)
      @username = username
      @password = password
    end

    def call
      raise Errors::BadRequest unless @username && @password

      if (user = Driver.find_by(username: @username)&.authenticate(@password))
        user_data = {
          user: {
            id: user[:id],
            username: user[:username],
            uuid: user[:uuid]
          },
          type: "driver"
        }
        access_token = Auth.issue(user_data)
        refresh_token = AuthCommands::AddRefreshTokenCommand.call(user[:uuid], "driver")
        return { access_token: access_token, user: DriverSerializer.new(user), refresh_token: refresh_token.result }
      else
        errors.add(:base, "Invalid username or password")
      end
    end
  end
end
