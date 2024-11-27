# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :balance_after, :type, :created_at, :updated_at

  belongs_to :driver
  belongs_to :admin, optional: true


end
