class Api::DriversController < ApplicationController
  before_action :authenticate_driver
  skip_before_action :authenticate_driver, only: [:login, :refresh_token, :create]

  def trip_histories
    render_json(ActiveModelSerializers::SerializableResource.new(@current_driver.trips, each_serializer: TripSerializer),
                status: :ok,
                message: "Trips fetched successfully"
    )
  end

  def get_information
    render_json(DriverSerializer.new(@current_driver, show_more_info: "detail"), status: :ok, message: "Driver fetched successfully")
  end

  def login
    command = DriverCommand::DriverAuthCommand.call(params[:username], params[:password])
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
    cmd = AuthCommands::CheckRefreshTokenCommand.call(cookies[:auth_token], "driver")
    if cmd.success?
      cookies[:auth_token] = cmd.result[:refresh_token]
      render json: { data: cmd.result }, status: :ok
    end
  end

  def create
    driver = Driver.new(driver_params)
    if driver.save
      render_json(DriverSerializer.new(driver, show_more_info: "detail"), status: :created, message: "Driver created successfully")
    else
      raise Errors::ApplicationError, driver.errors.full_messages
    end
  end

  def submit_kyc
    cmd = DriverCommand::SubmitKycCommand.call(@current_driver, kyc_param)
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "KYC submitted successfully")
    else
      raise Errors::ApplicationError, cmd.errors
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
