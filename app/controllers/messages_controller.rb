class MessagesController < ApplicationController
    before_action :set_chat
  
    def index
      messages = @chat&.messages&.map { |message| { body: message.body, number: message.number, created_at: message.created_at } } || []
      render json: messages, status: :ok
    end
  
    def create
      @message = @chat.messages.new(message_params)
      @message.number = $redis.incr("#{params[:application_id]}_#{params[:chat_id]}_message_counter")
      if @message.valid?
        exchange = MESSAGE_CHANNEL.default_exchange
        exchange.publish(@message.to_json(), routing_key: 'message.create')
        render json: {message_number: @message.number}, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    def update
      @message = Message.find_by(number: params[:id], chat_id: @chat.id)

      if @message.update(message_params)
        render json: { body: @message.body, number: @message.number, created_at: @message.created_at }, status: :ok
      else
        render json: { error: message.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def destroy
      @message = Message.find_by(number: params[:id], chat_id: @chat.id)
      
      if @message
        exchange = MESSAGE_CHANNEL.default_exchange
        exchange.publish({number: @message.number, chat_id: @chat.id}.to_json(), routing_key: 'message.delete')
        render json: { message: 'Message successfully deleted' }, status: :ok
      else
        render json: { error: 'Message not found' }, status: :not_found
      end
    end


    def search
      query = {
        query: {
          match: {
            body: params[:query]
          }
        },
        _source: ['body', 'number', 'created_at']
      }
    
      @messages = @chat.messages.search(query).records.map do |message|
        {
          body: message.body,
          number: message.number,
          created_at: message.created_at
        }
      end
    
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
  