Ichiban::Application.routes.draw do
  numeric = /\d+/

  
  # resources :sessions

  # Operators can view all records using the following routes.
  devise_for :users

  # devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }
  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
    get "signup", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end
  resources :users
  resources :reports
  resources :suspensions
  ##

  # We declare our routes manually instead of using the
  # resource method because our directory acts the identifier for public use.

  # Boards
  root to: 'boards#index'
  get '/:page' => 'boards#index', constraints: { page: numeric }

  resources 'boards' do
    resources :posts
    get  'search/' => 'boards#search'
    get  'search/:keyword' => 'boards#search'
    get  '/'      => 'boards#index',  :as => :boards
    get  '/:page' => 'boards#index',  :as => :boards, constraints: { page: numeric }
    post '/'      => 'boards#create', :as => :boards

    get    'new'              => 'boards#new',     :as => :new_board
    get    ':directory/edit'  => 'boards#edit',    :as => :edit_board
    get    ':directory'       => 'boards#show',    :as => :board
    get    ':directory/:page' => 'boards#show',    :as => :board, constraints: { page: numeric }
    put    ':directory'       => 'boards#update',  :as => :board
    delete ':directory'       => 'boards#destroy', :as => :board

    scope ':directory' do
      resources :users
      resources :reports
      resources :suspensions
    end
  end

  scope 'tripcodes' do
    get ':tripcode/'       => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/ }
    get ':tripcode/:page'  => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/, page: numeric }
  end
  

  scope '/manage' do
    get '/' => 'management#show', :as => :manage
    put '/' => 'management#update', :as => :manage
  end

  # A few nicities
  # get 'login' => 'sessions#new'
  # get 'logout' => 'sessions#destroy'
  


  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
