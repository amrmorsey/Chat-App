Rails.application.routes.draw do
  resources :applications, only: [:create, :show, :update, :destroy] do
    get 'total_chats'
    resources :chats, only: [:index, :create, :show] do
      resources :messages, only: [:index, :create] do
        collection do
          get 'search'
        end
      end
    end
  end
end
