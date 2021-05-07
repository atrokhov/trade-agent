Rails.application.routes.draw do
  resources :baskets
  resources :client_bonus
  resources :provider_bonus
  resources :contacts
  resources :instuctions
  scope :api do
    scope :v1 do
      get 'users/' => 'users#index'
      patch 'users/:id/' => 'users#update'
      get 'users/:id' => 'users#show'
      get 'users/:id/edit' => 'users#edit'
      patch 'users/:id/block' => 'users#block'
      get 'orders/new'
      get 'orders/:id/edit' => 'orders#edit'
      get 'waybills/new'
      get 'waybills/:id/edit' => 'waybills#edit'
      get 'subcategories/new'
      get 'subcategories/:id/edit' => 'subcategories#edit'
      get 'staffs/new'
      get 'staffs/:id/edit' => 'staffs#edit'
      patch 'staffs/:id/block' => 'staffs#block'
      get 'shops/new'
      get 'shops/:id/edit' => 'shops#edit'
      get 'providers/new'
      get 'providers/:id/edit' => 'providers#edit'
      get 'providers/:id/products' => 'providers#provider_products'
      patch 'providers/:id/block' => 'providers#block'
      get 'clients/new'
      get 'clients/:id/edit' => 'clients#edit'
      patch 'clients/:id/block' => 'clients#block'
      get 'products/new'
      get 'products/:id/edit' => 'products#edit'
      patch 'products/:id/block' => 'products#block'
      get 'districts/new'
      get 'districts/:id/edit' => 'districts#edit'

      resources :districts
      resources :shops
      resources :orders
      resources :invoices
      patch '/invoices/:id/complete' => 'invoices#complete_invoice'
      resources :waybills
      resources :provider_reviews
      resources :product_reviews
      resources :products
      resources :subcategories
      resources :staffs
      resources :providers
      resources :clients
      resources :categories
      resources :banners
      devise_for :users,
                 path: '',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 },
                 controllers: {
                   sessions: 'sessions',
                   registrations: 'registrations'
                 }, defaults: { format: :json }
      resources :blogs
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
