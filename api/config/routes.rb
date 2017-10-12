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

    resources :backgrounds, only: [:index]

    resources :projects do
      put :assign, on: :member, action: :assign_user
    end

    resources :rooms do
      resources :bookings, except: [:update]
    end
    resources :reports, only: [:index]
  end

  post "_ah/push-handlers/push/:token", to: "api/v1/backgrounds#send_email"

end
