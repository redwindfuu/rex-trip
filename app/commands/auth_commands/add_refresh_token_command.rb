module AuthCommands
  class AddRefreshTokenCommand
    prepend SimpleCommand
    def initialize(uuid, type)
      @uuid = uuid
      @type = type
    end

    def call
      refresh_token = RefreshToken.new
      refresh_token.uuid = @uuid
      refresh_token.type = @type
      refresh_token.save!
      refresh_token.token
    end
  end
end
