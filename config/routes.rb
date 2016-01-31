Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'account_activations/edit'

  get 'sessions/new'

    root 'static_pages#home'
    
    get 'help'      => 'static_pages#help' 
    get 'about'     => 'static_pages#about' 
    get 'signup'    => 'users#new' 
    get 'login'     => 'sessions#new'
    post 'login'    => 'sessions#create'
    delete 'logout' => 'sessions#destroy'
    
    resources :users
    resources :user_friendships do
      member do
        put :accept
        put :block
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: [:new, :create, :edit, :update]
    resources :microposts,          only: [:create, :destroy]
end
