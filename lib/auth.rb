require "jwt"
class Auth
  ALGORITHM = "HS256"
  def self.issue(payload)
    payload[:exp] = 1.hour.from_now.to_i
    JWT.encode(
      payload,
      auth_secret,
      ALGORITHM)
  end
  def self.decode(token)
    JWT.decode(token,
      auth_secret,
      true,
      { algorithm: ALGORITHM }).first
  end
  def self.auth_secret
    ENV["AUTH_SECRET"] || "my$ecret0p@ssw0rd"
  end
end
