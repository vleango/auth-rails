Rails.application.routes.draw do

  namespace :v1, defaults: { format: :json } do
    namespace :auth do
      post '/login' => 'authenticate#login'
      post '/register' => 'authenticate#register'
      post '/provider' => 'authenticate#provider'
      delete '/logout' => 'authenticate#logout'
    end
  end

end
