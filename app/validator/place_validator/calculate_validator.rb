module PlaceValidator 
  class CalculateValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        place_id: int_field,
        tos: arr_field
      }
    end

      # [{ to_place_id: int, order: int }]
      def check_tos
        tos = @params[:tos]
        tos.each do |from|
          to_place_id = from[:to_place_id]
          order = from[:order]
          name = from[:name]
          raise_error("to_place_id is required") if to_place_id.nil?
          raise_error("order is required") if order.nil?
          raise_error("name is required") if name.nil?
          raise_error("order must be a number") unless order.is_a?(Integer)
        end
      end
    
  end
end
