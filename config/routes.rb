Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, only: []
 
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root 'welcome#index'
  get '/welcome', to: 'welcome#index'
  resources :todos, only: [:create, :index, :destroy, :update]
  delete '/todos', to: 'todos#delete_all'
  get "/healthcheck", to: "health#show"
  post "/graphql", to: "graphql#execute"
  scope "auth" do
    post "/signup", to: "auth#signup"
    post "/login", to: "auth#login"
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
