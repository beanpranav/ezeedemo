Rails.application.routes.draw do
  resources :study_materials

  resources :chapters

  resources :subjects

  root 'pages#home'
  get "dashboard" => "pages#dashboard"

end
