Rails.application.routes.draw do

  get 'impressum' => 'meta#imprint'
  get 'map/:id' => 'index#index', as: 'map_detail'
  resources :maps, only: [:index, :show] do
    collection do
      get :search
    end
  end

  root 'index#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
