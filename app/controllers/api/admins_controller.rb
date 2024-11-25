# require 'errors/unauthorized'

class Api::AdminsController < ApplicationController
  before_action :authenticate_admin
  skip_before_action :authenticate_admin, only: [ :login, :refresh_token ]

  def review_kyc
    command = AdminCommands::ReviewKycCommand.call(@current_admin, params[:driver_id], params[:status], params[:review])
    if command.success?
      render json: { data: command.result }, status: :ok
    else
      raise Errors::Invalid, "Review failed"
    end
  end

  def get_drivers
    render json: { data: Driver.all }, status: :ok
  end

  def get_customers
    render json: { data: Customer.all }, status: :ok
  end

  def change_password
    command = AdminCommands::ChangePasswordCommand.call(@current_admin, change_password_params)
    if command.success? && command.result
      render json: command.result , status: :ok
    else
      raise Errors::ApplicationError, command.errors
    end
  end

  def get_trips
    render json: { data: Trip.all }, status: :ok
  end

  def get_information
    render json: { data: AdminSerializer.new(@current_admin) }, status: :ok
  end

  def login
    command = AdminCommands::AdminAuthCommand.call(params[:username], params[:password])
    if command.success? && command.result
      cookies[:auth_token] = command.result[:refresh_token]
      render json: {
        data: command.result,
        message: "You are logged in!"
      }, status: :ok
    else
      raise Errors::Unauthorized, "Invalid username or password"
    end
  end

  def logout
    acc = token
    add_blacklist_token(acc, "admin")
    AuthCommands::RemoveRefreshTokenCommand.call(cookies[:auth_token], "admin")
    render json: { message: "You are logged out!" }, status: :ok
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
    raise Errors::Unauthorized, "Unauthorized" unless auth_present?
    if auth["type"] == "admin" && !in_blacklist?(token, "admin")
      @current_admin = Admin.find_by(username: auth["user"][ "username" ])
      raise Errors::Unauthorized, "Unauthorized" unless @current_admin
    else
      raise Errors::Unauthorized, "Unauthorized"
    end
  end

  def change_password_params
    params.permit(:old_password, :new_password, :confirm_password)
  end
end
