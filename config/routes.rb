Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions, :passwords, :comfirmations]

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }, default: true) do
    devise_for :users, skip: [:registrations, :passwords],
      path_names: { sign_in: "login", sign_out: "logout" },
      controllers: {
        omniauth_callbacks: "api/v1/users/omniauth_callbacks",
        sessions: "api/v1/users/omniauth_callbacks"
      }

    devise_scope :user do
      get "/users/auth/gitlab/callback", to: "/api/v1/users/omniauth_callbacks#gitlab"
      delete "users/logout", to: "users/omniauth_callbacks#destroy"
    end

    resources :room_bookings, except: [:update], :path => "books" do
      post "search", on: :collection, action: "search"
    end

    get 'projects', to: '/api/v1/users#projects'

    scope 'admin', as: 'admin' do
      resources :projects
      resources :rooms
      get "reports", to: "/api/v1/reports#index"

      resources :user_projects, except: [:update, :destroy, :show] do
        put ':project_id', on: :collection, action: "update"
        delete ':project_id', on: :collection, action: "destroy"
      end
    end

  end

end

