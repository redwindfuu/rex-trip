# frozen_string_literal: true

module SystemValidator
  class EnterCodeValidator < ParamsChecker::BaseParamsChecker
    TYPES_INVITE = [ :CC , :CD, :DD , :DC ]
    def schema
      {
        code: char_field,
        from_uuid: char_field,
        type: char_field
      }
    end
    
    def check_type(type)
      unless TYPES_INVITE.include?(type.to_sym)
        raise_error("Type must be one of #{TYPES_INVITE.join(", ")}")
      end
      type
    end
  end
end
