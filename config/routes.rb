Rails.application.routes.draw do
  resources :applications, only: [:create, :index, :update, :destroy] do
    get 'total_chats'
    get '/applications', to: 'applications#index'
    resources :chats, only: [:index, :create, :update, :destroy] do
      get '/applications/:application_token/chats', to: 'chats#index'
      put 'messages', to: 'messages#update'
      resources :messages, only: [:index, :create, :update, :destroy] do
        get '/applications/:application_token/chats/:chat_number/messages', to: 'messages#index'
        collection do
          get 'search'
        end
      end
    end
  end
end
