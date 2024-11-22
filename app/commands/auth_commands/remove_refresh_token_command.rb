module AuthCommands
  class RemoveRefreshTokenCommand
    prepend SimpleCommand
    def initialize(token , token_type)
      @token = token
      @type = token_type
    end

    def call
      RefreshToken.find_by_token_and_type(@token, @type).destroy
    end
  end
end
