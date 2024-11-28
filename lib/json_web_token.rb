# frozen_string_literal: true

class JsonWebToken
  # 2 days
  def self.encode(payload, exp = 30.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
  rescue StandardError
    nil
  end

  def self.dynamic_key_decode(token, key)
    HashWithIndifferentAccess.new(JWT.decode(token, key)[0])
  rescue StandardError
    nil
  end
end