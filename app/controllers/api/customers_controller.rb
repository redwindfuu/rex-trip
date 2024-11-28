class Api::CustomersController < ApplicationController
  before_action :authenticate_customer
  skip_before_action :authenticate_customer, only: [ :login, :refresh_token, :create ]

  def trip_histories
    trips = Trip.where(customer_id: @current_customer.id)
    render_json(
      ActiveModelSerializers::SerializableResource.new(
        trips.page(pagination[:page]).per(pagination[:per_page]),
        each_serializer: TripSerializer),
        status: :ok,
        message: "Trips fetched successfully",
        meta: { total: trips.length }
    )
  end

  def get_information
    render json: { data: CustomerSerializer.new(@current_customer) }, status: :ok
  end

  def rate_trip
    cmd = TripCommands::RateTripCommand.call(@current_customer.id, params[:rating])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Trip rated successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end

  def request_trip
    cmd = TripCommands::RequestTripCommand.call(@current_customer.id, params)
    if cmd.success?
      render_json(cmd.result, status: :created, message: "Trip requested successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end


  def create
    validator = CustomerValidator::CreateCustomerValidator.call(params: create_customer_params)

    if validator.failure?
      raise Errors::Invalid, message: "Invalid input"
    end

    customer = Customer.new(create_customer_params)
    if customer.save!
      render json: { message: "Customer created successfully" }, status: :created
    else
      raise Errors::Invalid, customer.errors.full_messages
    end
  end

  def login
    cmd = CustomerCommands::CustomerAuthCommand.call(params[:username], params[:password])
    if cmd.success?
      cookies[:auth_token] = cmd.result[:refresh_token]
      render json: {
        data: cmd.result,
        message: "You are logged in!"
      }, status: :ok
    else
      raise Errors::Unauthorized, "Invalid username or password"
    end
  end

  def refresh_token
    cmd = AuthCommands::CheckRefreshTokenCommand.call(cookies[:auth_token], "customer")
    if cmd.success?
      cookies[:auth_token] = cmd.result[:refresh_token]
      render json: { data: cmd.result }, status: :ok
    else
        raise Errors::ApplicationError
    end

  end

  def logout
    acc = token
    add_blacklist_token(acc, "customer")
    AuthCommands::RemoveRefreshTokenCommand.call(cookies[:auth_token], "customer")
    render json: { message: "You are logged out!" }, status: :ok
  end

  private
  def authenticate_customer
    raise Errors::Unauthorized unless auth_present?
    if auth["type"] == "customer" && !in_blacklist?(token, "customer")
      @current_customer = Customer.find_by(username: auth["user"]["username"])
      raise Errors::Unauthorized unless @current_customer
    else
      raise Errors::Unauthorized
    end
  end

  def create_customer_params
    params.require(:customer)
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


end
