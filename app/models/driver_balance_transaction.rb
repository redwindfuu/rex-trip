class DriverBalanceTransaction < ApplicationRecord
  belongs_to :driver
  belongs_to :admin, foreign_key: :approved_by_id, optional: true

  enum status: { pending: 0, approved: 1, rejected: 2 }
  enum type: { withdrawn: 0, deposited: 1, trip_fee: 2 }

  validates :amount, presence: true
  validates :balance_after, presence: true
  validates :type, presence: true

  before_create :set_default_status


  def self.create_transaction(driver_id, amount, balance_after, type)
    transaction = DriverBalanceTransaction.create(
      driver_id: driver_id,
      amount: amount,
      balance_after: balance_after,
      type: type,
    )

    if type == :trip_fee
      transaction.status = statuses[:approved]
      transaction.approved_at = Time.zone.now
    end

    transaction.save!
  end

  private

  def set_default_status
    self.status = status[:pending] if self.status.nil?
    self.type = type[:trip_fee] if self.type.nil?
  end

end
