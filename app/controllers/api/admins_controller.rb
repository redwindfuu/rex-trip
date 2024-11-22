class Api::AdminsController < ApplicationController
  before_action :authenticate_admin, only: [:logout , :get_information]

  def get_information
    render json: { data: "hi" }, status: :ok
  end

  def login
    command = AdminCommands::AdminAuthCommand.call(params[:username], params[:password])
    if command.success? && command.result
      cookies[:auth_token] = command.result[:refresh_token]
      p command.result
      render json: {
        data: command.result,
        message: "You are logged in!"
      }, status: :ok
    else
      render json: { error: command.errors }, status: :unauthorized
    end

  end

  def logout
    acc = token
    add_blacklist_token(acc, "admin")
    AuthCommands::RemoveRefreshTokenCommand.call(cookies[:auth_token], "admin")
    json = { message: "You are logged out!" }
    render json: json, status: :ok
  end


  def refresh_token
    cmd = AuthCommands::CheckRefreshTokenCommand.call(cookies[:auth_token], "admin")
    if cmd.success?
      cookies[:auth_token] = cmd.result[:refresh_token]
      render json: { data: cmd.result }, status: :ok
    end
  end

  private
  def authenticate_admin
    if auth_present?
      p auth
      if auth["type"] == "admin" && !in_blacklist?(token, "admin")
        @current_admin = Admin.find_by(username: auth[:username])
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def add_blacklist_token(auth_token, type)
    BlacklistedToken.create(token: auth_token, type: type)
  end

  def in_blacklist?(auth_token , type)
    BlacklistedToken.find_by(token: auth_token, type: type)
  end
end
