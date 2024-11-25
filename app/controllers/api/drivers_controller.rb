class Api::DriversController < ApplicationController
  before_action :authenticate_driver
  skip_before_action :authenticate_driver, only: [ :login, :refresh_token, :create ]

  def trip_histories
    render json: { data: Trip.where(driver_id: @current_driver.id) }, status: :ok
  end

  def get_information
    render json: { data: DriverSerializer.new(@current_driver) }, status: :ok
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
      render json: { message: :"ok"}, status: :created
    else
      render json: driver.errors, status: :unprocessable_entity
    end
  end

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

end
