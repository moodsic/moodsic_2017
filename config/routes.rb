Rails.application.routes.draw do
  get 'locations' => 'location#new'
  post 'locations' => 'location#create'
  get 'locations/show' => 'location#show'
  get 'locations/error' => 'location#error'
  get 'locations/playlist' => 'location#playlist'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
