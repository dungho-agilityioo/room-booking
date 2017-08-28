# == Route Map
#
# WARNING: The rest_client gem is deprecated and will be removed from RubyGems. Please use rest-client gem instead.
#                                Prefix Verb     URI Pattern                                            Controller#Action
# api_v1_user_gitlab_omniauth_authorize GET|POST /api/v1/users/auth/gitlab(.:format)                    api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#  api_v1_user_gitlab_omniauth_callback GET|POST /api/v1/users/auth/gitlab/callback(.:format)           api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                                api_v1 GET      /api/v1/api/v1/users/auth/:provider/callback(.:format) api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#               new_api_v1_user_session GET      /api/v1/users(.:format)                                api/v1/users/omniauth_callbacks#test
#

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions, :passwords, :comfirmations]

  api_version(module: "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }, default: true) do
    devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {
      omniauth_callbacks: "api/v1/users/omniauth_callbacks",
      sessions: "api/v1/users/omniauth_callbacks"
    }

    devise_scope :user do
      get "/api/v1/users/auth/gitlab/callback", to: "users/omniauth_callbacks#gitlab"
    end
  end

  # devise_scope :user do
  #   get "/api/v1/users", to: "api/v1/users/omniauth_callbacks#gitlab", as: 'new_user_session'
  #   # delete "/api/v1/users/sign_out", to: "users/omniauth_callbacks#destroy"
  # end
end
