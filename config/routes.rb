Ichiban::Application.routes.draw do
  resources :boards do
    resources :posts
  end
end
