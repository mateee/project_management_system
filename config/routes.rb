Rails.application.routes.draw do
    
  #reports
  get 'reports/week' => 'reports#week', as: 'week_reports'
  post '/reports/update_all', to: 'reports#update_all', as: 'update_all_reports'
  post '/reports/create_all', to: 'reports#create_all', as: 'create_all_reports'
  post '/reports/approve', to: 'reports#approve', as: 'approve_reports'
  resources :reports
  post "reports/new"
  get '/reports/:project_id/sub_task.json' => 'reports#task_depend', as: 'task_depend', :format => :json
  
  
  #one_tasks
  resources :one_tasks
  post "one_tasks/new"
  get '/one_tasks/:id/import' => 'one_tasks#import', as: 'import_one_task'
  post '/one_tasks/:id/do_import' => 'one_tasks#do_import', as: 'do_import_one_task'
  post '/one_tasks/:id/update_all', to: 'one_tasks#update_all', as: 'update_all_one_task'
  
  #roles
  resources :roles
  post "roles/new"
  get '/myroles' => 'roles#myroles', as: 'my_roles'
  post '/roles/new_task' => 'roles#new_task', as: 'new_task_role'
  post '/roles/task' => 'roles#create_t_role', as: 'create_task_role'
  get '/dofun/:project_id/sub_user' => 'roles#dofun', as: 'dofun', :format => :json
  get '/proj_depend/:user_id/sub_user.json' => 'roles#proj_depend', as: 'proj_depend', :format => :json
  get '/set_projects_s' => 'roles#set_projects_s', as: 'set_projects_s', :format => :json
  
  # /dofun/:pre_user_id:/sub_user.json
  
  #projects
  resources :projects
  post "projects/new"
  
  #customers
  resources :customers
  post "customers/new"
  
  #users
  get '/users' => 'users#index', as: 'users'
  get '/users/:id', to: 'users#show', as: 'user'
  patch '/users/:id', to: 'users#update'
  get '/users/:id/edit', to: 'users#edit', as: 'edit_user'
  delete '/users/:id', to: 'clearance/users#destroy'
    
  #dashboard a home
  get 'dashboard/index'
  get 'home/index'
     #timesheets
     get 'dashboard/reports'
     post '/dashboard/approve_all', to: 'dashboard#approve_all', as: 'approve_all_dashboard'
     post '/dashboard/verde_approve', to: 'dashboard#verde_approve', as: 'verde_approve_dashboard'
     
  
  #root
  root 'home#index'
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  #Clearance routers  

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
