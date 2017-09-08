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

    resources :projects
    resources :rooms
    resources :room_bookings, except: [:update] do
      post "search", on: :collection, action: "search"
      post "booked", on: :collection, action: "room_booked"
    end

    post "reports/range_date", to: "/api/v1/reports#by_range_date"
    post "reports/projects", to: "/api/v1/reports#by_project"
    get 'users/projects', to: '/api/v1/users#projects'

    resources :user_projects, except: [:update, :destroy] do
      put ':project_id', on: :collection, action: "update"
      delete ':project_id', on: :collection, action: "destroy"
    end
  end

end
