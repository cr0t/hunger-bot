Rails.application.routes.draw do
  root to: 'pages#index'

  aa_config = ActiveAdmin::Devise.config
  aa_config[:controllers][:registrations] = 'users/registrations'

  devise_for :users, aa_config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  telegram_webhooks TelegramWebhooksController
end
