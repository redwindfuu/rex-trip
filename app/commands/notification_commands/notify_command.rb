module NotificationCommands
  class NotifyCommand
    
    prepend SimpleCommand

    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
      notify_user
      notify_admin
    end
    private

    def notify_user 
      p "Notify user" + @message
    end

    def notify_admin
      p "Notify admin" + @message
    end
    
  end
end
