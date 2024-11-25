class DriverBalanceTransaction < ApplicationRecord
  belongs_to :driver
  belongs_to :admin, foreign_key: :approved_by_id, optional: true

  enum status: { pending: 0, approved: 1, rejected: 2 }

  enum type: { credit: 0, debit: 1 }

  validates :amount, presence: true
  validates :balance_after, presence: true
  validates :type, presence: true

  before_create :set_default_status

  private

  def set_default_status
    self.status = status[:pending] if self.status.nil?
  end

end
