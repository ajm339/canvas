require 'session_controller'

Canvas::Application.routes.draw do
  get "users/create"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
   
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :user do
        resources :items do
          resources :versions
          resources :followers
        end
        get '/root_item', to: 'items#root', as: :user_root_item
        get '/root_item/versions', to: 'versions#root', as: :user_root_item_versions
        get '/root_item/versions/:id', to: 'versions#show', as: :user_root_item_version
        resources :workspaces
        post '/invite', to: 'invites#create', as: :send_invite
      end
    end
  end

  resources :users
  get '/login', to: 'session#new', as: :login
  post '/login', to: 'users#login', as: :save_login
  get '/join', to: 'users#join', as: :join
  post '/join', to: 'users#accept', as: :accept_invite

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  constraints SessionController.new do
    get '/', to: 'session#new', as: 'login_root'
  end
  get '/', to: 'items#index', as: 'root'
  get '/logout', to: 'users#logout', as: :logout

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
