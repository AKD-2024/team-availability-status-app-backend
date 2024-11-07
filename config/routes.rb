Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        collection do
          post :register
          post :login
          post :logout
        end
      end

      resources :availability_status, only: [ :create, :index ]

      post 'send-status-email', to: 'availability_status_email#send_email'
    end
  end
end
