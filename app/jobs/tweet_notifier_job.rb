class TweetNotifierJob < ApplicationJob
  queue_as :notifications

  def perform(*args)
    NotificationCommands::NotifyCommand.call("user", args[0])
  end
end
