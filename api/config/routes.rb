Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions, :passwords, :comfirmations]

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }) do
    devise_for :users, skip: [:registrations, :passwords],
      path_names: { sign_in: "login", sign_out: "logout" },
      controllers: {
        omniauth_callbacks: "api/v1/users/omniauth_callbacks",
        sessions: "api/v1/users/omniauth_callbacks"
      }

    devise_scope :user do
      get "/users/auth/gitlab/callback", to: "/api/v1/users/omniauth_callbacks#gitlab"
      delete "logout", to: "users/omniauth_callbacks#destroy"
      # delete :logout, to: :destroy, controller: :omniauth_callbacks
    end

    resources :room_bookings, except: [:update], :path => "books" do
      post :search, on: :collection, action: :search
    end

    get :projects, to: :projects, controller: :users

    resources :backgrounds, only: [:index]

    namespace :admin do
      resources :projects
      resources :rooms
      resources :reports, only: [:index]

      resources :user_projects, only: [:index, :create] do
        collection do
          put ':project_id', action: :update
          delete ':project_id', action: :destroy
        end
      end
    end

  end

  post "_ah/push-handlers/push/:token", to: "api/v1/backgrounds#send_email"

end
