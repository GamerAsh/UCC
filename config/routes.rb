UCC::Application.routes.draw do

    resources :users do
    resources :messages
    member do
      get :following, :followers

    end
    end
  resources :messages
  resources :relationships
  resources :sessions,      :only => [:new, :create, :destroy]
  resources :thoughts,    :only => [:create, :destroy]


  root :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/signup', :to => 'users#new'
  match '/recover', :to => 'recover#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'



end
