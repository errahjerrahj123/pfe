Rails.application.routes.draw do
  get 'partials/student'
  get 'partials/admin'
  get 'partials/employee'
  get 'configuration/index'
  get 'configuration/settings'
  get 'configuration/advanced'
  get 'configuration/add_weekly_holidays'
  get 'home/index'
  resources :users
resources :sessions, only: [:new, :create, :destroy]
get 'signup', to: 'users#new', as: 'signup'
get 'all', to: 'users#all'
get 'create', to: 'users#create'
get 'index', to: 'users#index'
get 'new' , to: 'users#new'
post '/users/listuser', to: 'users#listuser'
get 'user/profile/:id', to: 'user#profile', as: 'user_profile'


get 'login', to: 'sessions#new', as: 'login'
get 'utilisateurs' , to: 'users#utilisateurs'
get 'logout', to: 'sessions#destroy', as: 'logout'
get 'dashboard', to: 'sessions#dashboard'
#get 'new' , to: 'sessions#new'
get 'settings', to: 'configuration#settings'
get 'index', to: 'configuration#index'
get 'advanced', to: 'configuration#advanced'
get 'add_weekly_holidays', to: 'configuration#add_weekly_holidays'
 resources :courses do
    resources :batches
  end
 get 'index' , to: 'courses#index'
 get 'manage_courses', to: 'courses#manage_courses'
  put 'update' , to: 'courses#update'
 get 'edit' , to: 'courses#edit'
 get 'show' , to: 'courses#show'
 get 'new' , to: 'courses#new'
  get 'grouped_batches' , to: 'courses#grouped_batches'
 get 'destroy' , to: 'courses#destroy'
 get 'manage_batches', to: 'courses#manage_batches'
 get 'rechercher_par_filiere' , to: 'courses#rechercher_par_filiere'
 get 'batch_transfers/update_batch', to: 'batch_transfers#update_batch'
get 'grading_levels', to: 'grading_levels#index'
 get 'index', to: 'batch_transfers#index'
 resources :batch_transfers, only: [:index]

  #get 'update' , to: 'courses#update'
 get 'courses/new'
 get 'courses/index'
  #get 'courses/edit'
  #get 'courses/update'
 #get'courses/manage_courses'
 get 'new', to: 'grp_batches#new'
 get 'grp_batches/show_batches/:course_id/:id', to: 'grp_batches#show_batches', as: 'show_batches'
 #delete 'grp_batches/:id', to: 'grp_batches#destroy', as: 'grp_batch'
 delete '/grp_batches/:id', to: 'grp_batches#destroy', as: 'destroy_grp_batch'

 get 'destroy' , to: 'batches#destroy'
  #get 'destroy' , to: 'courses#destroy'
resources :student do
  post 'admission1', on: :collection
end
#resources :manage_courses, only: [:index, :destroy]

  get '/requestdoc_students/index', to: 'requestdoc_students#index'
get 'admission1' , to: 'student#admission1'
get 'profile/:id', to: 'student#profile'
 get 'student/sans_semestre/:id', to: 'student#sans_semestre', as: 'student_sans_semestre'
 get 'student/sans_semestre_sans_rattr/:id', to: 'student#sans_semestre_sans_rattr'
 get 'student/history/:id', to: 'student#history'
 get 'student/student_card/:id', to: 'student#student_card'
 get 'student/gestion_student_card/:id', to: 'student#gestion_student_card'
 
get 'new' , to: 'batches#new'

post 'courses/:course_id/create_batch_group', to: 'courses#create_batch_group', as: 'create_batch_group'


#post '/students', to: 'student#admission1'




 
resources :courses do
  member do
    get 'manage_courses'
    
  end

end
resources :grp_batches do
  collection do
    get 'new/:course_id', to: 'grp_batches#new', as: 'new_grp_batch'
    get 'grouped_batches', to: 'courses#grouped_batches'
  end
end
resources :batch_grps

end
