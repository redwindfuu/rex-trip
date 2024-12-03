class Api::SystemsController < ApplicationController
  before_action :is_auth?

  def invitees
    invitees = get_user.sent_invites.left_joins(:customer_inviteable, :driver_inviteable)
      .select("*").map do |invitee|
        {
          "created_at": invitee.created_at,
          "name_invitees": invitee.full_name,
          "phone_invitees": invitee.phone,
          "type_invitees": invitee.inviteable_type
        }
      end
    
    render_json(invitees, status: :ok, message: "Invitees fetched successfully") 
  end

  def enter_code
    cmd = SystemCommands::EnterCodeCommandV2.call(auth["user"]["uuid"], params[:code], params[:type])

    if cmd.success?
      render_json(cmd.result, status: :ok, message: "Code entered successfully")
    else
      render json: { error: cmd.errors }, status: :unprocessable_entity
    end
  end
  private

  def get_user 
    if auth["type"] == "customer"
      Customer.find_by(uuid: auth["user"]["uuid"])
    else
      Driver.find_by(uuid: auth["user"]["uuid"])
    end
  end
end
