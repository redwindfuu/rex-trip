require 'auth'
module AdminCommands
  class AdminAuthCommand
    prepend SimpleCommand

    def initialize(username = nil, password = nil)
      @username = username
      @password = password
    end

    def call
      if @username && @password
        if (user = Admin.find_by(username: @username)&.authenticate(@password))
          user_data = {
            user: {
              id: user[:id],
              username: user[:username],
              uuid: user[:uuid]
            },
            type: "admin"
          }
          p user_data
          access_token = Auth.issue(user_data)
          refresh_token = AuthCommands::AddRefreshTokenCommand.call(user[:uuid], "admin")
          return { access_token: access_token, user: AdminSerializer.new(user), refresh_token: refresh_token.result }
        else
          errors.add(:base, "Invalid username or password")
        end
      end

    end
  end
end
