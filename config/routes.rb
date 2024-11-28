Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace "api" do
    resources :admins, only: [] do
      collection do
        post "login" => "admins#login"
        post "logout" => "admins#logout"
        put "change-password" => "admins#change_password"
        post "refresh" => "admins#refresh_token"
        get "me" => "admins#get_information"
        get "trips" => "admins#get_trips"
        get "drivers" => "admins#get_drivers"
        get "drivers/transactions" => "admins#transactions"
        get "drivers/:id" => "admins#get_driver"
        put "drivers/:driver_id/kyc-review" => "admins#review_kyc"
        put "drivers/transactions/:transaction_id" => "admins#update_transaction"

        get "customers" => "admins#get_customers"
      end
    end

    resources :trips, only: [ :create ] do
      collection do
        get "available" => "trips#trip_available"
        get ":id" => "trips#show"
        put ":id" => "trips#update"
        delete ":id" => "trips#destroy"
      end
    end

    resources :places, only: [ :index, :show ]

    resources :customers, only: [ :create ] do
      collection do
        get "trips/histories" => "customers#trip_histories"
        post "trips/request" => "customers#request_trip"
        post "trips/:trip_id/rate" => "customers#rate_trip"
        post "login" => "customers#login"
        post "logout" => "customers#logout"
        post "refresh" => "customers#refresh_token"
        get "me" => "customers#get_information"
      end
    end

    resources :drivers, only: [ :create ] do
      collection do
        get "trips/histories" => "drivers#trip_histories"
        get "trips/available" => "drivers#available_trips"
        post "trips/:trip_id/approve" => "drivers#approve_trip"
        put "trips/:trip_id/change-status" => "drivers#change_trip_status"
        put "trips/:trip_id/payment" => "drivers#payment"
        get "transactions/histories" => "drivers#get_balance_transactions"
        post "transactions/request" => "drivers#request_balance"
        post "login" => "drivers#login"
        post "logout" => "drivers#logout"
        post "refresh" => "drivers#refresh_token"
        get "me" => "drivers#get_information"
        post "kyc" => "drivers#submit_kyc"
      end
    end

    resources :documents, only: [ :create, :show ]

    resources :systems, only: [] do
      collection do
        get "invitees" => "systems#invitees"
        post "invite" => "systems#enter_code"
      end
    end

  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/up", to: "health#up"

  # Defines the root path route ("/")
  # root "posts#index"
end