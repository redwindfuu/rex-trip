module AdminCommands
  class ChangePasswordCommand
    prepend SimpleCommand

    def initialize(admin, params)
      @admin = admin
      @params = params
    end


    def call
      raise Errors::Invalid, "Invalid password" unless @admin&.authenticate(@params[:old_password])
      if @params[:new_password] == @params[:confirm_password]
        @admin.update(password: @params[:new_password], password_confirmation: @params[:confirm_password])
        { message: "Password changed successfully" }
      else
        errors.add(:password, "Password and confirm password do not match")
        return
      end
    end
  end
end
