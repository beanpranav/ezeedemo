Rails.application.routes.draw do

  resources :interactive_contents

  resources :assessment_contents

  resources :video_contents do
    member do
      get :assessment_admin
    end
  end

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
