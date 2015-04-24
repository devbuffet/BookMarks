Fav::Application.routes.draw do
  #match "users/login" => "users#login", :via => [:post,:get]
  # get "welcome/index"

  match "bookmarks(/index)" => "articles#index"
  match "users/logout" => "sessions#logout"
  match "users/login" => "sessions#new"
  match 'bookmarks/:id/edit' => 'articles#edit'
  match 'bookmarks/:id/delete' => 'articles#destroy'
  match 'bookmarks/:id/show' => 'articles#show'
  match 'bookmarks/new' => 'articles#new'
  match "passwordresets/validateToken" => 'passwordresets#validateToken'
  match "users/forgotpassword" => 'passwordresets#new'
  # user profile
  match 'users/profile/(:name)' => 'users#profile'
  match 'bookmarks/category/(:category)' => 'articles#category'
  match "users/forgotpassword" => 'passwordresets#new'
  match 'follows/:id/delete' => 'follows#destroy'
  match 'follows/:id/add' => 'follows#add'
  
  resources :articles,:users,:sessions,:passwordresets,:follows

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'articles#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
