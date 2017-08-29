# == Route Map
#
#                                    Prefix Verb     URI Pattern                                         Controller#Action
#     api_v1_user_gitlab_omniauth_authorize GET|POST /api/v1/users/auth/gitlab(.:format)                 api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#      api_v1_user_gitlab_omniauth_callback GET|POST /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#  api_v1_api_v1_users_auth_gitlab_callback GET      /api/v1/api/v1/users/auth/gitlab/callback(.:format) api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                           api_v1_projects GET      /api/v1/projects(.:format)                          api/v1/projects#index {:format=>:json}
#                                           POST     /api/v1/projects(.:format)                          api/v1/projects#create {:format=>:json}
#                            api_v1_project GET      /api/v1/projects/:id(.:format)                      api/v1/projects#show {:format=>:json}
#                                           PATCH    /api/v1/projects/:id(.:format)                      api/v1/projects#update {:format=>:json}
#                                           PUT      /api/v1/projects/:id(.:format)                      api/v1/projects#update {:format=>:json}
#                                           DELETE   /api/v1/projects/:id(.:format)                      api/v1/projects#destroy {:format=>:json}
#                              api_v1_rooms GET      /api/v1/rooms(.:format)                             api/v1/rooms#index {:format=>:json}
#                                           POST     /api/v1/rooms(.:format)                             api/v1/rooms#create {:format=>:json}
#                               api_v1_room GET      /api/v1/rooms/:id(.:format)                         api/v1/rooms#show {:format=>:json}
#                                           PATCH    /api/v1/rooms/:id(.:format)                         api/v1/rooms#update {:format=>:json}
#                                           PUT      /api/v1/rooms/:id(.:format)                         api/v1/rooms#update {:format=>:json}
#                                           DELETE   /api/v1/rooms/:id(.:format)                         api/v1/rooms#destroy {:format=>:json}
#    default_user_gitlab_omniauth_authorize GET|POST /api/v1/users/auth/gitlab(.:format)                 api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#     default_user_gitlab_omniauth_callback GET|POST /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
# default_api_v1_users_auth_gitlab_callback GET      /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                          default_projects GET      /projects(.:format)                                 api/v1/projects#index {:format=>:json}
#                                           POST     /projects(.:format)                                 api/v1/projects#create {:format=>:json}
#                           default_project GET      /projects/:id(.:format)                             api/v1/projects#show {:format=>:json}
#                                           PATCH    /projects/:id(.:format)                             api/v1/projects#update {:format=>:json}
#                                           PUT      /projects/:id(.:format)                             api/v1/projects#update {:format=>:json}
#                                           DELETE   /projects/:id(.:format)                             api/v1/projects#destroy {:format=>:json}
#                             default_rooms GET      /rooms(.:format)                                    api/v1/rooms#index {:format=>:json}
#                                           POST     /rooms(.:format)                                    api/v1/rooms#create {:format=>:json}
#                              default_room GET      /rooms/:id(.:format)                                api/v1/rooms#show {:format=>:json}
#                                           PATCH    /rooms/:id(.:format)                                api/v1/rooms#update {:format=>:json}
#                                           PUT      /rooms/:id(.:format)                                api/v1/rooms#update {:format=>:json}
#                                           DELETE   /rooms/:id(.:format)                                api/v1/rooms#destroy {:format=>:json}
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
