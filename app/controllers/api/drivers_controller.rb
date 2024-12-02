class Api::DriversController < ApplicationController
  before_action :authenticate_driver
  skip_before_action :authenticate_driver, only: [ :login, :refresh_token, :create ]

  def trip_histories
    trips =  Trip.where(driver_id: @current_driver[:id]).order("created_at DESC").page(pagination[:page]).per(pagination[:per_page])
    render_json(
      ActiveModelSerializers::SerializableResource.new(
        trips,
                each_serializer: TripSerializer),
                status: :ok,
                message: "Trips fetched successfully",
                meta: pagination_meta(trips)
    )
  end

  def get_balance_transactions
    transactions = DriverBalanceTransaction
      .includes(:admin)
      .includes(:driver)
      .where(driver_id: @current_driver[:id])
      .order("created_at DESC")
      .page(pagination[:page])
      .per(pagination[:per_page])
    render_json(
      ActiveModelSerializers::SerializableResource.new(
        transactions,
        each_serializer: TransactionSerializer),
        status: :ok,
        message: "Transactions fetched successfully",
        meta: pagination_meta(transactions)
    )
  end

  def request_balance
    cmd = DriverCommands::RequestBalanceCommand.call(@current_driver[:id], params[:amount], params[:type])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Balance requested successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end



  def change_trip_status
    cmd = TripCommands::ChangeStatusTripCommand.call(@current_driver[:id], params[:trip_id], params[:status])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Trip status changed successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end

  def get_information
    render_json(DriverSerializer.new(@current_driver, show_more_info: "detail"), status: :ok, message: "Driver fetched successfully")
  end

  def login
    command = DriverCommands::DriverAuthCommand.call(params[:username], params[:password])
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
    add_blacklist_token(acc, "driver")
    AuthCommands::RemoveRefreshTokenCommand.call(cookies[:auth_token], "driver")
    render json: { message: "You are logged out!" }, status: :ok
  end

  def refresh_token
    # cmd = AuthCommands::CheckRefreshTokenCommand.call(cookies[:auth_token], "driver")
    # if cmd.success?
    #   cookies[:auth_token] = cmd.result[:refresh_token]
    #   render json: { data: cmd.result }, status: :ok
    # end
  end

  def create
    validator = DriverValidator::CreateDriverValidator.call(params: driver_params)
    if validator.failure?
      raise Errors::Invalid, validator.errors
    end
    driver = Driver.new(driver_params)
    if driver.save
      render_json(DriverSerializer.new(driver, show_more_info: "detail"), status: :created, message: "Driver created successfully")
    else
      raise Errors::ApplicationError, driver.errors.full_messages
    end
  end

  def submit_kyc
    cmd = DriverCommands::SubmitKycCommand.call(@current_driver, kyc_param)
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "KYC submitted successfully")
    else
      raise Errors::ApplicationError, cmd.errors
    end
  end

  def approve_trip
    cmd = TripCommands::ApproveTripCommand.call(@current_driver[:id], params[:trip_id])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Trip approved successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end

  def current_trip
    current_trip = Trip.where(driver_id: @current_driver[:id], status: [ 1, 2, 3 ]).first
    # current_trip = Trip.where.(driver_id: @current_driver[:id])
    if current_trip
      render_json(current_trip, status: :ok, message: "Current trip fetched successfully", serializer:)
    else
      render json: { error: "No current trip" }, status: :not_found
    end
  end

  def payment
    cmd = TripCommands::PayTripCommand.call(params[:trip_id], params[:amount])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Payment successful")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end


  # private methods below
  private

  def driver_params
    params.require(:driver)
          .permit(
            :email,
            :password,
            :password_confirmation,
            :full_name,
            :phone,
            :avatar_link,
            :username
          )
  end


  def authenticate_driver
    raise Errors::Unauthorized, "Unauthorized" unless auth_present?
    if auth["type"] == "driver" && !in_blacklist?(token, "driver")
      @current_driver = Driver.find(auth["user"]["id"])
      raise Errors::Unauthorized, "Unauthorized" unless @current_driver
    else
      raise Errors::Unauthorized, "Unauthorized"
    end
  end

  def kyc_param
    params.permit(
            :id_number,
            :front_side_link,
            :backside_link
          )
  end
end
