Desk::Application.routes.draw do
  resources :quizzes
  #match "/quiz/:quiz_id/questions/:id => quiz#show"
  resources :home
  resources :users
  resources :questions
  match "/user_answers" => "user_answers#update", :method => :put
  match "/users/login" => "users#login"
  match "/logout" => "users#logout"
  root :to => "home#index"
end
