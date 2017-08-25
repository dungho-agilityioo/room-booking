# == Route Map
#
#                                Prefix Verb     URI Pattern                                     Controller#Action
# api_v1_user_gitlab_omniauth_authorize GET|POST /users/auth/gitlab(.:format)                    api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#  api_v1_user_gitlab_omniauth_callback GET|POST /users/auth/gitlab/callback(.:format)           api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                                api_v1 GET      /api/v1/users/auth/:provider/callback(.:format) api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#               api_v1_new_user_session GET      /api/v1/sign_in(.:format)                       devise/sessions#new {:format=>:json}
#           api_v1_destroy_user_session GET      /api/v1/sign_out(.:format)                      devise/sessions#destroy {:format=>:json}
#                          api_v1_rooms GET      /api/v1/rooms(.:format)                         api/v1/rooms#index {:format=>:json}
#                                       POST     /api/v1/rooms(.:format)                         api/v1/rooms#create {:format=>:json}
#                           api_v1_room GET      /api/v1/rooms/:id(.:format)                     api/v1/rooms#show {:format=>:json}
#                                       PATCH    /api/v1/rooms/:id(.:format)                     api/v1/rooms#update {:format=>:json}
#                                       PUT      /api/v1/rooms/:id(.:format)                     api/v1/rooms#update {:format=>:json}
#                                       DELETE   /api/v1/rooms/:id(.:format)                     api/v1/rooms#destroy {:format=>:json}
#                       api_v1_projects GET      /api/v1/projects(.:format)                      api/v1/projects#index {:format=>:json}
#                                       POST     /api/v1/projects(.:format)                      api/v1/projects#create {:format=>:json}
#                        api_v1_project GET      /api/v1/projects/:id(.:format)                  api/v1/projects#show {:format=>:json}
#                                       PATCH    /api/v1/projects/:id(.:format)                  api/v1/projects#update {:format=>:json}
#                                       PUT      /api/v1/projects/:id(.:format)                  api/v1/projects#update {:format=>:json}
#                                       DELETE   /api/v1/projects/:id(.:format)                  api/v1/projects#destroy {:format=>:json}
# 

Rails.application.routes.draw do
  api_version(:module => "Api::V1", path: { value: "api/v1" }, defaults: { format: :json }) do
    devise_for :users, skip: [:registrations, :sessions, :passwords, :comfirmations],
      controllers: {
        omniauth_callbacks: 'api/v1/users/omniauth_callbacks'
      }
    devise_scope :user do
      get "/users/auth/:provider/callback", to: "users/omniauth_callbacks#gitlab"
      get 'sign_in', :to => '/devise/sessions#new', :as => :new_user_session
      get 'sign_out', :to => '/devise/sessions#destroy', :as => :destroy_user_session
    end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :rooms
    resources :projects
  end

end
