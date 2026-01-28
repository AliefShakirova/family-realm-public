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

  #статические страницы
  get 'about', to: 'pages#about', as: 'about'

  # отвечает исключительно за основную/главную страницу
  root 'posts#index'
end
