# == Route Map
#
# Prefix Verb   URI Pattern          Controller#Action
#  rooms GET    /rooms(.:format)     rooms#index
#        POST   /rooms(.:format)     rooms#create
#   room GET    /rooms/:id(.:format) rooms#show
#        PATCH  /rooms/:id(.:format) rooms#update
#        PUT    /rooms/:id(.:format) rooms#update
#        DELETE /rooms/:id(.:format) rooms#destroy
# 

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :rooms
end
