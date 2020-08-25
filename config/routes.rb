Rails.application.routes.draw do
  resources :program_service_groups
  resources :service_groups
  resources :locations
  resources :pocs
  resources :sites
  resources :programs
  resources :orgs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "/create_new_entry", to: "orgs#create_new_entry"
end
