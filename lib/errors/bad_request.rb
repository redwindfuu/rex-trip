module Errors
  class BadRequest < Errors::ApplicationError
    def initialize(message = "")
      super(
        title: "Bad Request",
        status: 400,
        detail: message || "The request could not be understood by the server due to malformed syntax."
      )
    end


    private
    attr_reader :errors
  end
end