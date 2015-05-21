Rails.application.routes.draw do

  resources :assessment_mock_fas do
    member do
      post :submit_test
      post :save_user_fa_progress
    end
  end

  resources :assessment_mock_sas do
    member do
      post :submit_test
    end
  end

  resources :content_tags

  mathjax 'mathjax'

  resources :interactive_contents

  resources :assessment_contents

  resources :video_contents do
    member do
      get :assessment_admin
      post 'add_tag'
      post 'remove_tag'
    end
  end

  devise_for :users
  
  resources :study_materials

  resources :chapters do
    member do
      get :study_mcqs
      get :study_shortqs
      get :study_longqs
      post 'save_user_study_progress'
      post 'save_user_assessment_progress'
    end
  end

  resources :subjects do
	  member do
	    get :subject_admin
      get :improve_predictive_score
	  end
	end

  root 'pages#home'
  get "common_dashboard" => "pages#common_dashboard"

end
