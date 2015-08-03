Spree::Core::Engine.routes.draw do
  post '/smspay', to: 'smspay#confirm', as: :smspay
  post '/smspay/success', to: 'smspay#success', as: :smspay_success
  post '/smspay/failure', to: 'smspay#failure', as: :smspay_failure
end
