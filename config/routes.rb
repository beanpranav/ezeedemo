Rails.application.routes.draw do
  devise_for :users
  resources :study_materials

  resources :chapters

  resources :subjects

  root 'pages#home'
  get "common_dashboard" => "pages#common_dashboard"
  get "report_card" => "pages#report_card"

end
