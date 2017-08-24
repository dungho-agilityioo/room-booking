# == Route Map
#
#   Prefix Verb   URI Pattern             Controller#Action
#    rooms GET    /rooms(.:format)        rooms#index
#          POST   /rooms(.:format)        rooms#create
#     room GET    /rooms/:id(.:format)    rooms#show
#          PATCH  /rooms/:id(.:format)    rooms#update
#          PUT    /rooms/:id(.:format)    rooms#update
#          DELETE /rooms/:id(.:format)    rooms#destroy
# projects GET    /projects(.:format)     projects#index
#          POST   /projects(.:format)     projects#create
#  project GET    /projects/:id(.:format) projects#show
#          PATCH  /projects/:id(.:format) projects#update
#          PUT    /projects/:id(.:format) projects#update
#          DELETE /projects/:id(.:format) projects#destroy
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :rooms
  resources :projects
end
