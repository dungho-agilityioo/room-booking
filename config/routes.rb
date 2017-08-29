# == Route Map
#
#                                    Prefix Verb     URI Pattern                                         Controller#Action
#     api_v1_user_gitlab_omniauth_authorize GET|POST /api/v1/users/auth/gitlab(.:format)                 api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#      api_v1_user_gitlab_omniauth_callback GET|POST /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#  api_v1_api_v1_users_auth_gitlab_callback GET      /api/v1/api/v1/users/auth/gitlab/callback(.:format) api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#    default_user_gitlab_omniauth_authorize GET|POST /api/v1/users/auth/gitlab(.:format)                 api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#     default_user_gitlab_omniauth_callback GET|POST /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
# default_api_v1_users_auth_gitlab_callback GET      /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#

Rails.application.routes.draw do

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }, default: true) do
    devise_for :users, skip: [:registrations, :sessions, :passwords, :comfirmations],
      path_names: { sign_in: "login", sign_out: "logout" },
      controllers: {
        omniauth_callbacks: "api/v1/users/omniauth_callbacks",
        sessions: "api/v1/users/omniauth_callbacks"
      }

    devise_scope :user do
      get "/api/v1/users/auth/gitlab/callback", to: "users/omniauth_callbacks#gitlab"
    end

    resources :projects
    resources :rooms

  end
end
