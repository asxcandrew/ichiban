Ichiban::Application.routes.draw do

  # We declare our routes manually instead of using the
  # resource method because our primary key is the
  # board's directory.

  # Boards
  root to: 'boards#index'
  scope 'boards' do
    get  '/' => 'boards#index',  :as => :boards
    post '/' => 'boards#create', :as => :boards

    get 'new' => 'boards#new', :as => :new_board
    get ':directory/edit' => 'boards#edit', :as => :edit_board

    get    ':directory' => 'boards#show',   :as => :board
    put    ':directory' => 'boards#update', :as => :board
    delete ':directory' => 'boards#destroy', :as => :board


    # Posts
    scope ':directory' do
      get  '/' => 'posts#index',  :as => :board_posts
      post '/' => 'posts#create', :as => :board_posts

      get 'new'      => 'posts#new',  :as => :new_board_post
      get ':id/edit' => 'posts#edit', :as => :edit_board_post

      get    ':id' => 'posts#show',   :as => :board_post
      put    ':id' => 'posts#update', :as => :board_post
    end
    delete 'posts/:id' => 'posts#destroy_with_tripcode', :as => :destroy_with_tripcode_board_post

  end

  resources :operators
  resources :sessions
  resources :reports

  mount Attachinary::Engine => "/attachinary"

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
