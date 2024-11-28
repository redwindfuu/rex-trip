# require 'errors/unauthorized'

class Api::AdminsController < ApplicationController
  before_action :authenticate_admin
  skip_before_action :authenticate_admin, only: [:login, :refresh_token]

  def transactions
      begin
      transactions = DriverBalanceTransaction.all
      render_json(ActiveModelSerializers::SerializableResource.new(
          transactions.page(pagination[:page]).per(pagination[:per_page]),
          each_serializer: TransactionSerializer),
                  status: :ok,
                  meta: { total: transactions.length },
                  message: "Transactions fetched successfully"
      )
    rescue Exception => e
      raise Errors::ApplicationError, e.message
    end
  end

  def update_transaction
    command = AdminCommands::UpdateTransactionCommand.call(@current_admin, params[:transaction_id], params[:status])
    if command.success?
      render json: { message: "Transaction updated successfully", data: nil }, status: :ok
    else
      raise Errors::Invalid, "Transaction update failed"
    end
  end

  def review_kyc
    command = AdminCommands::ReviewKycCommand.call(@current_admin, params[:driver_id], params[:status], params[:kyc_review])
    if command.success?
      render json: { message: "Review successful", data: nil }, status: :ok
    else
      raise Errors::Invalid, "Review failed"
    end
  end

  def get_drivers
    begin
      drivers = Driver.all
      render_json(ActiveModelSerializers::SerializableResource.new(
          drivers.page(pagination[:page]).per(pagination[:per_page]),
          each_serializer: DriverSerializer, show_more_info: "detail"),
                  status: :ok,
                  meta: { total: drivers.length },
                  message: "Drivers fetched successfully"
      )
    rescue Exception => e
      raise Errors::ApplicationError, e.message
    end
  end

  def get_driver
    driver = Driver.find(params[:id])
    render_json(DriverSerializer.new(driver, show_more_info: "detail"),
                status: :ok,
                message: "Driver fetched successfully")
  end

  def get_customers
    begin
      customers = Customer.all
      render_json(ActiveModelSerializers::SerializableResource.new(
        customers.page(pagination[:page]).per(pagination[:per_page]),
        each_serializer: CustomerSerializer),
                  status: :ok,
                  meta: { total: customers.length },
                  message: "Customers fetched successfully"
      )
    rescue Exception => e
      raise Errors::ApplicationError, e.message
    end
  end

  def change_password
    command = AdminCommands::ChangePasswordCommand.call(@current_admin, change_password_params)
    if command.success? && command.result
      render json: { message: "Password changed successfully" }, status: :ok
    else
      raise Errors::ApplicationError, command.errors
    end
  end

  def get_trips
    begin
      trips = Trip.all
      render_json(ActiveModelSerializers::SerializableResource.new(
        trips.page(pagination[:page]).per(pagination[:per_page]),
        each_serializer: TripSerializer),
                  status: :ok,
                  meta: { total: trips.length },
                  message: "Trips fetched successfully"
      )
    rescue Exception => e
      raise Errors::ApplicationError, e.message
    end
  end

  def get_information
    render_json(AdminSerializer.new(@current_admin), status: :ok, message: "Admin information fetched successfully")
  end

  def login
    command = AdminCommands::AdminAuthCommand.call(params[:username], params[:password])
    if command.success? && command.result
      cookies[:auth_token] = command.result[:refresh_token]
      render_json(command.result, status: :ok, message: "Login successful")
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
      @current_admin = Admin.find_by(username: auth["user"]["username"])
      raise Errors::Unauthorized, "Unauthorized" unless @current_admin
    else
      raise Errors::Unauthorized, "Unauthorized"
    end
  end

  def change_password_params
    params.permit(:old_password, :new_password, :confirm_password)
  end

end
