Ichiban::Application.routes.draw do

  resources :posts
  resources :users
  resources :sessions
  resources :reports
  resources :suspensions

  # We declare our routes manually instead of using the
  # resource method because our primary key is the
  # board's directory.

  # Boards
  root to: 'boards#index'
  scope 'boards' do
    get  '/' => 'boards#index',  :as => :boards
    post '/' => 'boards#create', :as => :boards

    get    'new'              => 'boards#new',     :as => :new_board
    get    ':directory/edit'  => 'boards#edit',    :as => :edit_board
    get    ':directory'       => 'boards#show',    :as => :board
    get    ':directory/:page' => 'boards#show',    :as => :board, constraints: { page: /\d+/ }
    put    ':directory'       => 'boards#update',  :as => :board
    delete ':directory'       => 'boards#destroy', :as => :board

    scope ':directory' do
      resources :users
    end
  end

  scope 'tripcodes' do
    get ':tripcode/'       => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/ }
    get ':tripcode/:page'  => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/, page: /\d+/ }
  end
  
  

  scope '/manage' do
    get '/' => 'management#show', :as => :manage
    put '/' => 'management#update', :as => :manage
  end

  # A few nicities
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  


  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
