class DriverSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :phone, :avatar_link, :username

  def avatar_link
    # get domain from env variable
    domain = ENV["DOMAIN"]
    # get the avatar link
    # if the avatar link is nil, return nil
    # else, return the full link
    # domain + avatar_link
    object.avatar_link.nil? ? nil : domain + object.avatar_link
  end
end