Ichiban::Application.routes.draw do

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
    get    ':directory/:page' => 'boards#show',    :as => :board
    put    ':directory'       => 'boards#update',  :as => :board
    delete ':directory'       => 'boards#destroy', :as => :board
  end

  # FIXME: Fix issue where tripcodes with periods cause routing errors.
  scope 'tripcodes' do
    scope 'secure' do
      get ':tripcode/' => 'tripcodes#show', 
          :as => :secure_tripcode, 
          secure: true, 
          constraints: { tripcode: /[^\/]+/ }

      get ':tripcode/:page' => 'tripcodes#show', 
          :as => :secure_tripcode, 
          secure: true, 
          constraints: { tripcode: /[^\/]+/ }
    end

    get ':tripcode/'       => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/ }
    get ':tripcode/:page'  => 'tripcodes#show', :as => :tripcode, constraints: { tripcode: /[^\/]+/ }
  end
  

  resources :posts
  resources :users
  resources :sessions
  resources :reports
  resources :suspensions
  

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
