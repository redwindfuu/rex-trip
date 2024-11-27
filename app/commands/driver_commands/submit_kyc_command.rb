# frozen_string_literal: true

module DriverCommands
  class SubmitKycCommand
    prepend SimpleCommand

    def initialize(driver, kyc_params)
      @driver = driver
      @kyc_params = kyc_params
    end

    def call
      driver = @driver
      raise Errors::NotFound, "Driver not found" unless driver
      driver.id_number = @kyc_params[:id_number]
      driver.front_side_link = @kyc_params[:front_side_link]
      driver.backside_link = @kyc_params[:backside_link]
      driver.kyc_review = ""
      driver.kyc_at = Time.now.in_time_zone
      driver.status= Driver.statuses[:pending]
      driver.save!
    end

  end
end
