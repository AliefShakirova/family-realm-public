Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'}

  #профиль текущуего пользователя
  resource :user_profile, only: [:show, :edit, :update]

  #пользователи
  resources :users

  #посты
  resources :posts

  resources :groups do

    post :invite, on: :member

    resources :ancestors do
      member do
        delete :purge_document
      end

      resources :relationships, only: [:new, :create, :destroy]
    end
  end

  #статические страницы
  get 'about', to: 'pages#about', as: 'about'

  get "invites/:token", to: "group_invitations#show", as: :invite

  post "invites/:token/accept", to: "group_invitations#accept", as: :accept_invite

  # отвечает исключительно за основную/главную страницу
  root 'posts#index'
end
