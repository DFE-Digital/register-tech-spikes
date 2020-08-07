Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "contacts#index"
  get "/edit/:contact_id" => "contacts#edit", as: "edit"
  post "/update" => "contacts#update", as: "update"
  post "/create" => "contacts#create", as: "create"
  get "/new" => "contacts#new", as: "new"
  post "/destroy" => "contacts#destroy", as: "destroy"
end
