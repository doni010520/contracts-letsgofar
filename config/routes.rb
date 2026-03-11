Rails.application.routes.draw do
  # Home
  root 'home#index'
  
  # Autenticação simples
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # Contratos (área autenticada)
  resources :contracts do
    member do
      post :send_for_signature
      post :cancel
      post :duplicate
      get :preview
      get :download_pdf
      get :edit_content
      patch :update_content
    end
    
    resources :signers, only: [:create, :destroy] do
      member do
        post :resend_email
      end
    end
  end
  
  # Templates
  resources :contract_templates do
    member do
      get :preview
      post :duplicate
    end
  end
  
  # Assinatura pública (sem autenticação)
  scope :sign do
    get ':token', to: 'signatures#show', as: :public_sign
    post ':token', to: 'signatures#create'
    get ':token/success', to: 'signatures#success', as: :sign_success
    get ':token/refused', to: 'signatures#refused', as: :sign_refused
    post ':token/refuse', to: 'signatures#refuse'
  end
  
  # Health check
  get 'health', to: 'home#health'
end
