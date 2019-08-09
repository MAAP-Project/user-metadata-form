Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questionnaires do
    member do
      delete :files
      post :clone
    end
  end

  namespace :api do
    namespace :v1 do
      resources :questionnaires
    end
  end
  root 'questionnaires#new'
end
