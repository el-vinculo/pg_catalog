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
  post "/update_programs", to: "orgs#update_programs"
  post "/update_sites", to: "orgs#update_sites"
  post "/catalog_search", to: "orgs#catalog_search"
  post "/advanced_search", to: "orgs#advanced_search"

end
