class Api::SystemsController < ApplicationController
  before_action :is_auth?
  # deliver_now and deliver_later
  def invitees
    invitees = get_user.sent_invites
      .left_joins(:customer_inviteable, :driver_inviteable)
      .page(params[:page]).per(params[:per_page]).order(created_at: :desc)
      .select("*")
      .map do |invitee|
        {
          "created_at": invitee.created_at,
          "name_invitees": invitee.full_name,
          "phone_invitees": invitee.phone,
          "type_invitees": invitee.inviteable_type
        }
      end
    # customer join left invitees_friends 
    #          join left driver on driver.id = invitees_friends.inviteable_id and invitees_friends.inviteable_type = "Driver"
    #         join left customer on customer.id = invitees_friends.inviteable_id and invitees_friends.inviteable_type = "Customer"
    render_json(invitees, status: :ok, message: "Invitees fetched successfully", meta: pagination_meta(invitees)) 
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
