module Errors
  class Invalid < Errors::ApplicationError
    def initialize(message = "")
      @status = 422
      @title = "Unprocessable Entity"
      @detail = message || "The request was well-formed but was unable to be followed due to semantic errors."
    end

    def serializable_hash
      {
        detail: detail,
        errors: errors,
        status: status,
        title: title
      }
    end

    private

    attr_reader :errors
  end
end