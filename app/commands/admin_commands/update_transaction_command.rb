# frozen_string_literal: true

module AdminCommands
  class UpdateTransactionCommand

    prepend SimpleCommand

    attr_accessor :transaction_id, :status, :current_admin

    def initialize(current_admin, transaction_id, status)
      @transaction_id = transaction_id
      @status = status.to_sym
      @current_admin = current_admin
    end

    def call
      transaction = DriverBalanceTransaction.find_by(id: transaction_id)

      if transaction.nil? || transaction.transaction_status.to_sym != :pending
        errors.add(:error, "Transaction not found")
        return
      end

      if status == :approved
        transaction.transaction_status = DriverBalanceTransaction.transaction_statuses[:approved]
        transaction.approved_at = Time.now
        transaction.approved_by_id = current_admin.id
        transaction.save!

        driver = transaction.driver
        driver.balance += transaction.amount
        driver.save!
      elsif status == :rejected
        transaction.transaction_status =  DriverBalanceTransaction.transaction_statuses[:rejected]
        transaction.approved_at = Time.now
        transaction.approved_by_id = current_admin.id
        transaction.save!
      else
        errors.add(:error, "Status is invalid")
      end
    end
  end
end
