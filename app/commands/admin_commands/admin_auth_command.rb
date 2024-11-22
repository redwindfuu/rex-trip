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
                username: user[:username]
              },
              type: "admin"
            }
            p user_data
            access_token = Auth.issue(user_data)
            refresh_token = AuthCommands::AddRefreshTokenCommand.call(user[:id], "admin")
            return { access_token: access_token, user: user_data[:user], refresh_token: refresh_token.result }
          else
            errors.add :authentication, "Wrong Pass"
          end
        end
    end
  end
end
