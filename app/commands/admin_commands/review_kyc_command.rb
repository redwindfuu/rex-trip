# frozen_string_literal: true

class AdminCommands::ReviewKycCommand
  prepend SimpleCommand

  def initialize(admin, driver_id, status, review = "")
    @admin = admin
    @driver_id = driver_id
    @status = status
    @review = review
  end

  def call
    driver = Driver.find_by(id: @driver_id)
    if driver.nil?
      errors.add(:error, "Driver not found")
      nil
    end
    driver.status= get_status
    driver.kyc_review= @review
    driver.kyc_by= @admin
    driver.kyc_at= Time.now.to_datetime
    driver.save
  end

  private

  def get_status
    case @status
    when "approved"
      Driver.statuses[:approved]
    when "rejected"
      Driver.statuses[:rejected]
    else
      Driver.statuses[:pending]
    end
  end
end

