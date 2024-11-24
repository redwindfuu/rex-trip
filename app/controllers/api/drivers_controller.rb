class Api::DriversController < ApplicationController

  def trip_histories

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

end
