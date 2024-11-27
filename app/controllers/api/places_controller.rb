class Api::PlacesController < ApplicationController

  def index
    @places = Place.all
    render_json(
      ActiveModelSerializers::SerializableResource.new(
        @places.page(pagination[:page]).per(pagination[:per_page]),
        each_serializer: PlaceSerializer),
      status: :ok,
      meta: { total: @places.length },
      message: "Places fetched successfully"
    )
  end

  def show
    cmd = PlaceCommands::PlaceDetailCommand.call(params[:id])
    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Place fetched successfully")
    else
      raise Errors::NotFound, cmd.errors
    end
  end


  private
  def place_params
    params.require(:place).permit(:name)
  end

end
