class TweetNotifierJob < ApplicationJob
  queue_as :notifications

  def perform(*args)
    NotificationCommands::NotifyCommand.call("user", args[0])
  end

  def self.cron_job
    p "Hello World from cron job"
  end
end
