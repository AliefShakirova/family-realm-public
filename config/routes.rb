Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' }

  resource :user_profile, only: [:show, :edit, :update]

  resources :timeline_events, only: [:edit, :update, :destroy]

  resources :users

  resources :posts

  resources :archives

  resources :groups do
    member do
      get :tree
      post :make_connection
      get :timeline
      post :add_timeline_event
    end

    post :invite, on: :member

    get :members, on: :member

    resources :ancestors do
      member do
        delete :purge_document
      end

      resources :relationships, only: [:new, :create, :destroy]
    end

    resources :locations
    resources :events
    resources :stories
  end

  get 'about', to: 'pages#about', as: 'about'

  get "invites/:token", to: "group_invitations#show", as: :invite

  post "invites/:token/accept", to: "group_invitations#accept", as: :accept_invite

  root 'posts#index'
end
