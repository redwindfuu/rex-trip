require 'auth'

module AuthCommands
  class CheckRefreshTokenCommand
    prepend SimpleCommand
    # time to live for refresh token is 30 days
    TIME_TO_LIVE = 30.days
    def initialize(refresh_token, type)
      @refresh_token = refresh_token
      @type = type
    end

    
    def call
      @refresh_token_data = RefreshToken.find_by_token(@refresh_token)
      now = Time.now
      if !@refresh_token_data.nil? && @refresh_token_data[:created_at].to_i + TIME_TO_LIVE.to_i > now.to_i
        user = nil
        case @type
        when "admin"
          user = Admin.find_by(id: @refresh_token_data[:uuid])
        else
          # add Customer model and Driver model
        end
        unless user.nil?
          payload = {
            user: {
              id: user.id,
              username: user.username,
            },
            type: @type
          }
          access_token = Auth.issue(payload)
          refresh_token = AuthCommands::AddRefreshTokenCommand.call(user.id, @type)
          @refresh_token_data.destroy
          data = { access_token: access_token, user: {
            id: user.id,
            username: user.username,
          }, refresh_token: refresh_token.result }
          p data
          data
        end
      end
    end
  end
end
