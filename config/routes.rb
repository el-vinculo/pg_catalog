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
  post "/service_group_list", to: "orgs#service_group_list"
  post "/population_group_list", to: "orgs#population_group_list"
  post "/service_tag_list", to: "orgs#service_tag_list"
  post "/favorite_query_list", to: "orgs#favorite_query_list"
  post "/delete_favorite_query", to: "orgs#delete_favorite_query"
  post "/filter_service_tag", to: "orgs#filter_service_tag"
  post "/get_entry_by_domain", to: "orgs#get_entry_by_domain"
  post "/remove_unnecessary_service_tags", to: "orgs#remove_unnecessary_service_tags"

end
