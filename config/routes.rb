Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "people#index"
  get "/edit/:person_id" => "people#edit", as: "edit"
  post "/update" => "people#update", as: "update"
  post "/create" => "people#create", as: "create"
  get "/new" => "people#new", as: "new"
end
