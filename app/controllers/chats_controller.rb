class ChatsController < ApplicationController
    before_action :set_application
    
    def index
      chats = @application&.chats&.map { |chat| { name: chat.name, messages_count: chat.messages_count, number: chat.number, created_at: chat.created_at } } || []
      render json: chats, status: :ok
    end

    def create
      @chat = @application.chats.new(chat_params)
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

    def chat_params
      params.require(:chat).permit(:name)
    end

  end
  