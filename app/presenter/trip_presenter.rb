class TripPresenter < BasePresenter
  def as_json(options = {})
    driver = @model.driver
    customer = @model.customer
    p options[:show_more_info] == "detail"
    res = {
      id: @model.id,
      fight_no: @model.fight_no,
      uuid: @model.uuid,
      driver: driver ? {
        id: driver[:id],
        full_name: driver[:full_name],
        email: driver[:email],
        phone: driver[:phone],
        uuid: driver[:uuid],
        avatar_link: driver[:avatar_link]
      } : nil,
      customer: {
        id: customer[:id],
        full_name: customer[:full_name],
        email: customer[:email],
        phone: customer[:phone],
        uuid: customer[:uuid],
        avatar_link: customer[:avatar_link]
      },
      seat: @model.seat,
      total_price: @model.total_price,
      booking_time: @model.booking_time,
      start_time_est: @model.start_time_est,
      status: @model.trip_status,
      created_at: @model.created_at,
      updated_at: @model.updated_at
    }
    if options[:show_more_info] == "detail"
      res[:depart_place] = {
        id: @model.depart_place[:id],
        name: @model.depart_place[:name]
      }
      res[:arrivals] = @model.arrivals.map do |arrival|
        {
          id: arrival[:id],
          name: arrival[:name],
          order: arrival[:order_place]
        }
      end
    end
    res
  end
end
