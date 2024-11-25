

class ApplicationController < ActionController::API
  # include Response
  # include ExceptionHandler
  # include ActionController::MimeResponds
  include ActionController::Cookies
  include Api::ErrorHandler

  private
  def token
    request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
  end
  def auth
    Auth.decode(token)
  end
  def auth_present?
    !!request.env.fetch("HTTP_AUTHORIZATION",
                        "").scan(/Bearer/).flatten.first
  end
  def add_blacklist_token(auth_token, type)
    BlacklistedToken.create(token: auth_token, type: type)
  end

  def in_blacklist?(auth_token, type)
    BlacklistedToken.find_by(token: auth_token, type: type)
  end

end
