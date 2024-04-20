class ApplicationsController < ApplicationController

    def index
      applications = Application.all.map { |app| { token: app.token, name: app.name, created_at: app.created_at , chats_count: app.chats_count} } || []
      render json: applications, status: :ok
    end

    def update
      application = Application.find_by(token: params[:id])
      if application.update(application_params)
        render json: { name: @application.name, token: @application.token }, status: :ok
      else
        render json: { errors: application.errors }, status: :unprocessable_entity
      end
    end

    def create
      @application = Application.new(application_params)
      @application.token = generate_unique_token
      if @application.save
        render json: { name: @application.name, token: @application.token }, status: :created
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    end

    def destroy
      application = Application.find_by(token: params[:id])
      if application
        exchange = APPLICATION_CHANNEL.default_exchange
        exchange.publish({token: params[:id]}.to_json(), routing_key: 'application.delete')
        render json: { message: 'Application and associated chats and messages deleted successfully' }, status: :ok
      else
        render json: { error: 'Failed to delete application' }, status: :unprocessable_entity
      end
    end

    def total_chats
      @total_chats = Chat.total_chats_by_application(params[:application_id])
  
      render json: { total_chats: @total_chats }
    end
  
    private
  
    def application_params
      params.require(:application).permit(:name)
    end

    def generate_unique_token
      loop do
        token = SecureRandom.hex(10)
        break token unless Application.exists?(token: token)
      end
    end

  end
  