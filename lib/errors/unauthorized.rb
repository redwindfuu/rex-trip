# Description: Unauthorized error class
module Errors
  class Unauthorized < Errors::ApplicationError
    def initialize(message = nil)
      super(
        title: "Unauthorized",
        status: 401,
        detail: message || "You need to login to authorize this request.",
      )
    end
  end
end
