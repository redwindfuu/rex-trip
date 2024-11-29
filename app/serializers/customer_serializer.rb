# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  full_name       :string
#  email           :string
#  phone           :string
#  avatar_link     :string
#  username        :string
#  password_digest :string
#  amount_invite   :integer
#  invite_code     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :username, :email, :full_name, :phone, :avatar_link, :created_at, :invite_code, :invite_amount

  def avatar_link
    # get domain from env variable
    domain = ENV["DOMAIN"]
    # get the avatar link
    # if the avatar link is nil, return nil
    # else, return the full link
    # domain + avatar_link
    object.avatar_link.nil? ? nil : object.avatar_link
  end

  def invite_amount
    object.amount_invite
  end
end
