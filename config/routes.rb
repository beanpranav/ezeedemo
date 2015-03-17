Rails.application.routes.draw do

  resources :video_contents

  devise_for :users
  resources :study_materials

  resources :chapters

  resources :subjects do
	  member do
	    get :subject_admin
	  end
	end

  root 'pages#home'
  get "common_dashboard" => "pages#common_dashboard"
  get "report_card" => "pages#report_card"

end
