class MessagesController < ApplicationController
    before_action :set_chat
  
    def index
      messages = @chat.messages
      render json: messages, status: :ok
    end
  
    def create
      @message = @chat.messages.new(message_params)
      @message.number = @chat.messages.count + 1
      if @message.save
        render json: {message_number: @message.number}, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end


    def search
      query = {
        query: {
          match: {
            body: params[:query]
          }
        }
      }
    
      @messages = @chat.messages.search(query).records
    
      render json: @messages
    end


    private
  
    def set_chat
      @application = Application.find_by!(token: params[:application_id])
      unless @application
        render json: { error: 'Application not found' }, status: :not_found
        return
      end
      @chat = Chat.find_by(application_id: @application.id, number: params[:chat_id])
      unless @chat
        render json: { error: 'Chat not found' }, status: :not_found
        return
      end
    end
  
    def message_params
      params.require(:message).permit(:body)
    end
  end
  