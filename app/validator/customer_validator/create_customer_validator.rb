# frozen_string_literal: true

module CustomerValidator
  class CreateCustomerValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        email: char_field,
        password: char_field,
        password_confirmation: char_field,
        full_name: char_field,
        phone: char_field,
        avatar_link: char_field(required: false),
        username: char_field
      }
    end
  end
end
