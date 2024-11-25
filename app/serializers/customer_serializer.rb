# frozen_string_literal: true

class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :full_name, :phone, :avatar_link, :created_at, :invite_code, :invite_amount

  def avatar_link
    # get domain from env variable
    domain = ENV["DOMAIN"]
    # get the avatar link
    # if the avatar link is nil, return nil
    # else, return the full link
    # domain + avatar_link
    object.avatar_link.nil? ? nil : domain + object.avatar_link
  end

  def invite_amount
    object.amount_invite
  end
end
