class AddKycReviewToDrivers < ActiveRecord::Migration[7.0]
  def change
    add_column :drivers, :kyc_review, :text
  end
end
