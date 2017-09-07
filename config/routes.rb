# == Route Map
#
#                                        Prefix Verb            URI Pattern                                         Controller#Action
#         user_google_oauth2_omniauth_authorize GET|POST        /api/v1/users/auth/google_oauth2(.:format)          devise/omniauth_callbacks#passthru
#          user_google_oauth2_omniauth_callback GET|POST        /api/v1/users/auth/google_oauth2/callback(.:format) devise/omniauth_callbacks#google_oauth2
#                       new_api_v1_user_session GET             /api/v1/users/login(.:format)                       api/v1/users/omniauth_callbacks#new {:format=>:json}
#                           api_v1_user_session POST            /api/v1/users/login(.:format)                       api/v1/users/omniauth_callbacks#create {:format=>:json}
#                   destroy_api_v1_user_session DELETE|POST|GET /api/v1/users/logout(.:format)                      api/v1/users/omniauth_callbacks#destroy {:format=>:json}
#  api_v1_user_google_oauth2_omniauth_authorize GET|POST        /api/v1/users/auth/google_oauth2(.:format)          api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#   api_v1_user_google_oauth2_omniauth_callback GET|POST        /api/v1/users/auth/google_oauth2/callback(.:format) api/v1/users/omniauth_callbacks#google_oauth2 {:format=>:json}
#                      new_api_v1_user_password GET             /api/v1/users/password/new(.:format)                api/v1/passwords#new {:format=>:json}
#                     edit_api_v1_user_password GET             /api/v1/users/password/edit(.:format)               api/v1/passwords#edit {:format=>:json}
#                          api_v1_user_password PATCH           /api/v1/users/password(.:format)                    api/v1/passwords#update {:format=>:json}
#                                               PUT             /api/v1/users/password(.:format)                    api/v1/passwords#update {:format=>:json}
#                                               POST            /api/v1/users/password(.:format)                    api/v1/passwords#create {:format=>:json}
#               cancel_api_v1_user_registration GET             /api/v1/users/cancel(.:format)                      api/v1/registrations#cancel {:format=>:json}
#                  new_api_v1_user_registration GET             /api/v1/users/sign_up(.:format)                     api/v1/registrations#new {:format=>:json}
#                 edit_api_v1_user_registration GET             /api/v1/users/edit(.:format)                        api/v1/registrations#edit {:format=>:json}
#                      api_v1_user_registration PATCH           /api/v1/users(.:format)                             api/v1/registrations#update {:format=>:json}
#                                               PUT             /api/v1/users(.:format)                             api/v1/registrations#update {:format=>:json}
#                                               DELETE          /api/v1/users(.:format)                             api/v1/registrations#destroy {:format=>:json}
#                                               POST            /api/v1/users(.:format)                             api/v1/registrations#create {:format=>:json}
#             api_v1_users_auth_gitlab_callback GET             /api/v1/users/auth/gitlab/callback(.:format)        api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                               api_v1_projects GET             /api/v1/projects(.:format)                          api/v1/projects#index {:format=>:json}
#                                               POST            /api/v1/projects(.:format)                          api/v1/projects#create {:format=>:json}
#                                api_v1_project GET             /api/v1/projects/:id(.:format)                      api/v1/projects#show {:format=>:json}
#                                               PATCH           /api/v1/projects/:id(.:format)                      api/v1/projects#update {:format=>:json}
#                                               PUT             /api/v1/projects/:id(.:format)                      api/v1/projects#update {:format=>:json}
#                                               DELETE          /api/v1/projects/:id(.:format)                      api/v1/projects#destroy {:format=>:json}
#                                  api_v1_rooms GET             /api/v1/rooms(.:format)                             api/v1/rooms#index {:format=>:json}
#                                               POST            /api/v1/rooms(.:format)                             api/v1/rooms#create {:format=>:json}
#                                   api_v1_room GET             /api/v1/rooms/:id(.:format)                         api/v1/rooms#show {:format=>:json}
#                                               PATCH           /api/v1/rooms/:id(.:format)                         api/v1/rooms#update {:format=>:json}
#                                               PUT             /api/v1/rooms/:id(.:format)                         api/v1/rooms#update {:format=>:json}
#                                               DELETE          /api/v1/rooms/:id(.:format)                         api/v1/rooms#destroy {:format=>:json}
#                          api_v1_room_bookings GET             /api/v1/room_bookings(.:format)                     api/v1/room_bookings#index {:format=>:json}
#                                               POST            /api/v1/room_bookings(.:format)                     api/v1/room_bookings#create {:format=>:json}
#                           api_v1_room_booking GET             /api/v1/room_bookings/:id(.:format)                 api/v1/room_bookings#show {:format=>:json}
#                                               DELETE          /api/v1/room_bookings/:id(.:format)                 api/v1/room_bookings#destroy {:format=>:json}
#                   api_v1_room_bookings_search POST            /api/v1/room_bookings/search(.:format)              api/v1/room_bookings#search {:format=>:json}
#                   api_v1_room_bookings_booked POST            /api/v1/room_bookings/booked(.:format)              api/v1/room_bookings#room_booked {:format=>:json}
#                     api_v1_reports_range_date POST            /api/v1/reports/range_date(.:format)                api/v1/reports#by_range_date {:format=>:json}
#                       api_v1_reports_projects POST            /api/v1/reports/projects(.:format)                  api/v1/reports#by_project {:format=>:json}
#                      new_default_user_session GET             /users/login(.:format)                              api/v1/users/omniauth_callbacks#new {:format=>:json}
#                          default_user_session POST            /users/login(.:format)                              api/v1/users/omniauth_callbacks#create {:format=>:json}
#                  destroy_default_user_session DELETE|POST|GET /users/logout(.:format)                             api/v1/users/omniauth_callbacks#destroy {:format=>:json}
# default_user_google_oauth2_omniauth_authorize GET|POST        /api/v1/users/auth/google_oauth2(.:format)          api/v1/users/omniauth_callbacks#passthru {:format=>:json}
#  default_user_google_oauth2_omniauth_callback GET|POST        /api/v1/users/auth/google_oauth2/callback(.:format) api/v1/users/omniauth_callbacks#google_oauth2 {:format=>:json}
#                     new_default_user_password GET             /users/password/new(.:format)                       api/v1/passwords#new {:format=>:json}
#                    edit_default_user_password GET             /users/password/edit(.:format)                      api/v1/passwords#edit {:format=>:json}
#                         default_user_password PATCH           /users/password(.:format)                           api/v1/passwords#update {:format=>:json}
#                                               PUT             /users/password(.:format)                           api/v1/passwords#update {:format=>:json}
#                                               POST            /users/password(.:format)                           api/v1/passwords#create {:format=>:json}
#              cancel_default_user_registration GET             /users/cancel(.:format)                             api/v1/registrations#cancel {:format=>:json}
#                 new_default_user_registration GET             /users/sign_up(.:format)                            api/v1/registrations#new {:format=>:json}
#                edit_default_user_registration GET             /users/edit(.:format)                               api/v1/registrations#edit {:format=>:json}
#                     default_user_registration PATCH           /users(.:format)                                    api/v1/registrations#update {:format=>:json}
#                                               PUT             /users(.:format)                                    api/v1/registrations#update {:format=>:json}
#                                               DELETE          /users(.:format)                                    api/v1/registrations#destroy {:format=>:json}
#                                               POST            /users(.:format)                                    api/v1/registrations#create {:format=>:json}
#            default_users_auth_gitlab_callback GET             /users/auth/gitlab/callback(.:format)               api/v1/users/omniauth_callbacks#gitlab {:format=>:json}
#                              default_projects GET             /projects(.:format)                                 api/v1/projects#index {:format=>:json}
#                                               POST            /projects(.:format)                                 api/v1/projects#create {:format=>:json}
#                               default_project GET             /projects/:id(.:format)                             api/v1/projects#show {:format=>:json}
#                                               PATCH           /projects/:id(.:format)                             api/v1/projects#update {:format=>:json}
#                                               PUT             /projects/:id(.:format)                             api/v1/projects#update {:format=>:json}
#                                               DELETE          /projects/:id(.:format)                             api/v1/projects#destroy {:format=>:json}
#                                 default_rooms GET             /rooms(.:format)                                    api/v1/rooms#index {:format=>:json}
#                                               POST            /rooms(.:format)                                    api/v1/rooms#create {:format=>:json}
#                                  default_room GET             /rooms/:id(.:format)                                api/v1/rooms#show {:format=>:json}
#                                               PATCH           /rooms/:id(.:format)                                api/v1/rooms#update {:format=>:json}
#                                               PUT             /rooms/:id(.:format)                                api/v1/rooms#update {:format=>:json}
#                                               DELETE          /rooms/:id(.:format)                                api/v1/rooms#destroy {:format=>:json}
#                         default_room_bookings GET             /room_bookings(.:format)                            api/v1/room_bookings#index {:format=>:json}
#                                               POST            /room_bookings(.:format)                            api/v1/room_bookings#create {:format=>:json}
#                          default_room_booking GET             /room_bookings/:id(.:format)                        api/v1/room_bookings#show {:format=>:json}
#                                               DELETE          /room_bookings/:id(.:format)                        api/v1/room_bookings#destroy {:format=>:json}
#                  default_room_bookings_search POST            /room_bookings/search(.:format)                     api/v1/room_bookings#search {:format=>:json}
#                  default_room_bookings_booked POST            /room_bookings/booked(.:format)                     api/v1/room_bookings#room_booked {:format=>:json}
#                    default_reports_range_date POST            /reports/range_date(.:format)                       api/v1/reports#by_range_date {:format=>:json}
#                      default_reports_projects POST            /reports/projects(.:format)                         api/v1/reports#by_project {:format=>:json}
#

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
    end

    resources :projects
    resources :rooms
    resources :room_bookings, except: [:update]
    post "room_bookings/search", to: "/api/v1/room_bookings#search"
    post "room_bookings/booked", to: "/api/v1/room_bookings#room_booked"

    post "reports/range_date", to: "/api/v1/reports#by_range_date"
    post "reports/projects", to: "/api/v1/reports#by_project"
  end

end
