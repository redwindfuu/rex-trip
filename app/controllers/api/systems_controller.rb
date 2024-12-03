class Api::SystemsController < ApplicationController
  before_action :is_auth?

  def invitees
    # invitees = get_user.sent_invites
    # .joins("LEFT JOIN drivers AS from_drivers ON from_drivers.id = invitees_friends.from_id AND invitees_friends.from_type = 'Driver'")
    # .joins("LEFT JOIN customers AS from_customers ON from_customers.id = invitees_friends.from_id AND invitees_friends.from_type = 'Customer'")
    # .select(
    #   "invitees_friends.created_at as created_at",
    #   "CASE 
    #       WHEN invitees_friends.from_type = 'Driver' THEN from_drivers.full_name
    #       WHEN invitees_friends.from_type = 'Customer' THEN from_customers.full_name
    #       ELSE 'Unknown'
    #   END AS name_invitees",
    #   "CASE 
    #       WHEN invitees_friends.from_type = 'Driver' THEN from_drivers.phone
    #       WHEN invitees_friends.from_type = 'Customer' THEN from_customers.phone
    #       ELSE 'Unknown'
    #   END AS phone_invitees",
      
    #   "invitees_friends.from_type as type_invitees",
    #   "invitees_friends.id as id"
    # )

    invitees_table = Invitee.arel_table
    drivers_table = Driver.arel_table
    customers_table = Customer.arel_table

    name_case = Arel::Nodes::Case.new(invitees_table[:from_type])
      .when("Driver").then(drivers_table[:full_name])
      .when("Customer").then(customers_table[:full_name])
      .else("Unknown")

    phone_case = Arel::Nodes::Case.new(invitees_table[:from_type])
      .when("Driver").then(drivers_table[:phone])
      .when("Customer").then(customers_table[:phone])
      .else("Unknown")

    invitees = get_user.sent_invites
      .joins("LEFT JOIN drivers AS from_drivers ON from_drivers.id = invitees_friends.from_id AND invitees_friends.from_type = 'Driver'")
      .joins("LEFT JOIN customers AS from_customers ON from_customers.id = invitees_friends.from_id AND invitees_friends.from_type = 'Customer'")
      .select(
        invitees_table[:created_at],
        name_case.as("name_invitees"),
        phone_case.as("phone_invitees"),
        invitees_table[:from_type].as("type_invitees"),
        invitees_table[:id]
      )
    
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
