class ChatsController < ApplicationController
    before_action :set_application, only: [:create]
    def create
      @chat = @application.chats.new
      @chat.set_chat_number

      if @chat.valid?
        exchange = CHAT_CHANNEL.default_exchange
        exchange.publish(@chat.to_json(), routing_key: 'chat.create')
        render json: { chat_number: @chat.number }, status: :created
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_application
      @application = Application.find_by!(token: params[:application_id])
    end
  end
  