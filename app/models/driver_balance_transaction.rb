class DriverBalanceTransaction < ApplicationRecord
  belongs_to :driver
  belongs_to :admin, foreign_key: :approved_by_id, optional: true

  enum transaction_status: { pending: 0, approved: 1, rejected: 2 }
  enum transaction_type: { withdrawn: 0, deposited: 1, trip_fee: 2 }

  validates :amount, presence: true
  validates :balance_after, presence: true


  before_create :set_default_status


  def self.create_transaction(driver_id, amount, balance_after, type)
    transaction = DriverBalanceTransaction.create(
      driver_id: driver_id,
      amount: amount,
      balance_after: balance_after,
      transaction_type: type.to_i,
    )

    if type == :trip_fee
      transaction.transaction_status = DriverBalanceTransaction.transaction_statuses[:approved]
      transaction.approved_at = Time.zone.now
    end

    transaction.save!
  end

  private

  def set_default_status
    self.transaction_status = DriverBalanceTransaction.transaction_statuses[:pending] if self.transaction_status.nil?
    self.transaction_type = DriverBalanceTransaction.transaction_types[:trip_fee] if self.transaction_type.nil?
  end

end
