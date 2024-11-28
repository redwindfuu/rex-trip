# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :transaction_status, :balance_after, :transaction_type, :created_at, :updated_at

  belongs_to :driver
  belongs_to :admin, optional: true


end
