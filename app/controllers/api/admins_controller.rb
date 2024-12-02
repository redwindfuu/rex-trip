# require 'errors/unauthorized'

class Api::AdminsController < ApplicationController
  before_action :authenticate
  skip_before_action :authenticate, only: [ :login, :refresh_token ]

  def transactions
    transactions = DriverBalanceTransaction.all
        .eager_load(:driver)
        .eager_load(:admin)
      .page(pagination[:page])
      .per(pagination[:per_page])
    .order("driver_balance_transactions.created_at DESC")
    render_json(
      CollectionPresenter.new(transactions, DriverBalanceTransactionPresenter),
                  status: :ok,
                  meta: pagination_meta(transactions),
                  message: "Transactions fetched successfully"
      )
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
    drivers = Driver.all.order("updated_at DESC").page(pagination[:page]).per(pagination[:per_page])
      render_json(
        CollectionPresenter.new(drivers, DriverPresenter),
                  status: :ok,
                  meta: pagination_meta(drivers),
                  message: "Drivers fetched successfully"
      )
  end

  def get_driver
    driver = Driver.find(params[:id])
    binding.pry
    render_json(
      DriverPresenter.new(driver, show_more_info: "detail"), 
                status: :ok,
                message: "Driver fetched successfully")
  end

  def get_customers
    customers = Customer.all.page(pagination[:page]).per(pagination[:per_page])
    render_json(ActiveModelSerializers::SerializableResource.new(
        customers,
        each_serializer: CustomerSerializer),
                  status: :ok,
                  meta: pagination_meta(customers),
                  message: "Customers fetched successfully"
      )
  end


  def get_customer
    customer = Customer.find(params[:id])
    render_json(CustomerSerializer.new(customer), status: :ok, message: "Customer fetched successfully")
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
    trips = Trip.all
      render_json(ActiveModelSerializers::SerializableResource.new(
        trips.page(pagination[:page]).per(pagination[:per_page]),
        each_serializer: TripSerializer),
                  status: :ok,
                  meta: { total: trips.length },
                  message: "Trips fetched successfully"
      )
  end

  def get_information
    render_json(AdminSerializer.new(@current_admin), status: :ok, message: "Admin information fetched successfully")
  end

  def login
    command = AdminCommands::AdminAuthCommand.call(params[:username], params[:password])
    if command.success? && command.result
      cookies[:auth_token_admin] = command.result[:refresh_token]
      render_json(command.result, status: :ok, message: "Login successful")
    else
      raise Errors::Unauthorized, "Invalid username or password"
    end
  end

  def logout
    acc = token
    add_blacklist_token(acc, "admin")
    AuthCommands::RemoveRefreshTokenCommand.call(cookies[:auth_token_admin], "admin")
    render json: { message: "You are logged out!" }, status: :ok
  end

  def refresh_token
    
  end

  def send_mail 
    render_json({}, status: :ok, message: "Mail sent successfully")
  end

  private

  # def authenticate_admin
  #   raise Errors::Unauthorized, "Unauthorized" unless auth_present?
  #   if auth["type"] == "admin" && !in_blacklist?(token, "admin")
  #     @current_admin = Admin.find_by(username: auth["user"]["username"])
  #     raise Errors::Unauthorized, "Unauthorized" unless @current_admin
  #   else
  #     raise Errors::Unauthorized, "Unauthorized"
  #   end
  # end

  def authenticate
    unless admin_token.present? && current_admin.present?
      render json: { authentication: 'Not Authorized.' }, status: 401
    end
  end

  def admin_token
    @admin_token ||= JsonWebToken.decode(request.headers['RexyAdmin-Authorization'])
  end

  def current_admin
    @current_admin ||= RexyAdmin.auth_model.auth_query.find_by_id(admin_token[:admin_id])
    # @current_admin ||= model.auth_query.find_by_id(admin_token[:admin_id])
  end

  def change_password_params
    params.permit(:old_password, :new_password, :confirm_password)
  end
end
