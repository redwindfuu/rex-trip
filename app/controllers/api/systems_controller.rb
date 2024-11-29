class Api::SystemsController < ApplicationController
  before_action :is_auth?

  def invitees
    my_uuid = auth["user"]["uuid"]
    invitees = InvitedFriend.get_invitees(my_uuid)
    render_json(invitees, status: :ok, message: "Invitees fetched successfully")
  end

  def enter_code
    cmd = SystemCommands::EnterCodeCommand.call(auth["user"]["uuid"], params[:code], params[:type])

    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Code entered successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end
end
