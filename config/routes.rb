Rails.application.routes.draw do
  root :to => 'home#dashboard'
  get 'frontend/get_gocart_details'
  get 'home/change_settings'
  get 'home/faq_page'
  get 'home/contact_us'
  patch 'home/update_shop'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
