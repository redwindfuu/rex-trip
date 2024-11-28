# frozen_string_literal: true

module AdminCommands
  class UpdateTransactionCommand

    prepend SimpleCommand

    attr_accessor :transaction_id, :status, :current_admin

    def initialize(transaction_id, status, current_admin)
      @transaction_id = transaction_id
      @status = status
      @current_admin = current_admin
    end

    def call
      transaction = Transaction.find_by(id: transaction_id)

      if transaction.nil?
        errors.add(:error, "Transaction not found")
        return
      end

      if status == :approved
        transaction.status = Transaction.statuses[:approved]
        transaction.approved_at = Time.now
        transaction.approved_by_id = current_admin.id
        transaction.save!
      elsif status == :rejected
        transaction.status = Transaction.statuses[:rejected]
        transaction.save!
      else
        errors.add(:error, "Status is invalid")
      end
    end
  end
end
