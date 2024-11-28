class Api::TripsController < ApplicationController
  def trip_available
    trips = Trip.get_available
    render_json(
      ActiveModelSerializers::SerializableResource.new(trips, each_serializer: TripSerializer),
      status: :ok, message: "Trips fetched successfully")
  end
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @trips = Trip.paginate(page: page, per_page: per_page)
    render_json(@trips, status: :ok , meta: { total: @trips.total_entries })
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      render_json(@trip, status: :created)
    else
      render_json(@trip.errors, status: :unprocessable_entity)
    end
  end

  def show
    @trip = Trip.find(params[:id])
    render_json(@trip, status: :ok)
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      render_json(@trip, status: :ok)
    else
      render_json(@trip.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    render_json(@trip, status: :ok)
  end




  private
  def trip_params
    params.require(:trip).permit(:name, :description, :start_date, :end_date, :budget)
  end

end
