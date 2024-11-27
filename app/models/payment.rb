class Payment < ApplicationRecord
  has_one :trip

  validates :amount, presence: true, numericality: { greater_than: 0 }

  enum method: { cash: 0, credit_card: 1, visa: 2, master_card: 3, paypal: 4 }

  enum status: { pending: 0, success: 1, failed: 2 }

  before_create :before_request

  def before_request
    self.time_event = Time.zone.now
    self.status = Payment.statuses[:success]
  end

  def self.check_payment_enough(trip_id , total)
    payments = Payment.where(trip_id: trip_id)
    total_payment = payments.sum(:amount)
    return total_payment >= total
  end

end
