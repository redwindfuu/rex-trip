
class DriverBalanceTransactionPresenter < BasePresenter
  def as_json (options = {})
    res = {
        id: @model["id"],
        amount: @model["amount"],
        transaction_status: @model["transaction_status"],
        balance_after: @model["balance_after"],
        transaction_type: @model["transaction_type"],
        created_at: @model["created_at"],
        updated_at: @model["updated_at"],
        driver: {
          id: @model.driver.id,
          full_name: @model.driver.full_name,
          email: @model.driver.email,
          phone: @model.driver.phone,
          avatar_link: @model.driver.avatar_link,
          username: @model.driver.username
        }
    }

    if @model.admin.present? 
      res.merge!(
        {
          admin: {
            id: @model.admin.id,
            username: @model.admin.username
          }
        }
      )
    end

    res
  end
end
