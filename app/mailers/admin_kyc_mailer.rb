class AdminKycMailer < ApplicationMailer
  def reject (driver)
    @driver = driver
    mail(to: @driver.email, subject: "KYC Rejected")
  end
end
