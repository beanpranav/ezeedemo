Rails.application.routes.draw do
  resources :chapters

  resources :subjects

  root 'pages#home'
  # get "about" => "pages#about"

end
