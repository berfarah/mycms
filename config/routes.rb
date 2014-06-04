Rails.application.routes.draw do
  get 'tags/index'

  get 'tags/new'

  get 'tags/create'

  get 'tags/destroy'

  get 'tags/show'

  get 'tags/edit'

	devise_for 	:users,
				:path => '',
				:path_names => {
					:sign_in => 'login',
					:sign_out => 'logout',
					:sign_up => 'register',
					:edit => 'profile'
				},
				:controllers => {
					:registrations => "registrations",
					:confirmations => 'confirmations'
				}

	devise_scope :user do
		patch "/confirmation" => "confirmations#confirm"
		put "/confirmation" => "confirmations#confirm"
		get "/confirmation" => "confirmations#show"
	end
	resources :posts # Don't actually want a page called posts
	resources :design, controller: 'posts', type: 'Design', :id => /.*/
	resources :music, controller: 'posts', type: 'Music', :id => /.*/
	resources :shared, controller: 'posts', type: 'Shared', :id => /.*/
	scope '/page' do
		resources :page, type: 'Page', :except => [:show, :update, :destroy], :path => ''
	end
	resources :tags

	root 'page#home'
	get '404', :to => 'page#page_not_found'
	resources :page, type: 'Page', :only => [:show, :update, :destroy], :path => ''


	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	# root 'welcome#index'

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
