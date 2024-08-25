Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          post 'show_api_key'
          post 'regenerate_api_key'
        end
      end

      resources :geolocations, param: :ip_address, except: [:edit] do
        constraints(ip_address: /[^\/]+/) do
          get :show, on: :member
          put :update, on: :member
          delete :destroy, on: :member
        end
      end
    end
  end
end
