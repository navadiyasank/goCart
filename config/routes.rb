Rails.application.routes.draw do
  root :to => 'home#dashboard'
  get 'frontend/get_gocart_details'
  patch 'home/update_shop'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
