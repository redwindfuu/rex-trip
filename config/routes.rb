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
        get "drivers/:id" => "admins#get_driver"
        put "drivers/:driver_id/kyc-review" => "admins#review_kyc"
        get "driver/transactions" => "admins#driver_transactions"
        put "driver/transactions/:id" => "admins#update_transaction"
        get "customers" => "admins#get_customers"
      end
    end

    resources :trips, only: [ :index , :create, :show, :update, :destroy ] do

    end

    resources :places, only: [ :index, :show]

    resources :customers, only: [ :create ] do
      collection do
        get "trips/histories" => "customers#trip_histories"
        post "login" => "customers#login"
        post "logout" => "customers#logout"
        post "refresh" => "customers#refresh_token"
        get "me" => "customers#get_information"
      end
    end

    resources :drivers, only: [ :create ] do
      collection do
        get "trips/histories" => "drivers#trip_histories"
        post "login" => "drivers#login"
        post "logout" => "drivers#logout"
        post "refresh" => "drivers#refresh_token"
        get "me" => "drivers#get_information"
        post "kyc" => "drivers#submit_kyc"
      end
    end

    resources :documents, only: [ :create, :show ]

    resources :systems, only: [] do

    end

  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/up", to: "health#up"

  # Defines the root path route ("/")
  # root "posts#index"
end