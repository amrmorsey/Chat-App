class ApplicationsController < ApplicationController

    def index
      applications = Application.all.map { |app| { token: app.token, name: app.name, created_at: app.created_at , chats_count: app.chats_count} } || []
      render json: applications, status: :ok
    end

    def update
      application = Application.find_by(token: params[:id])
      if application.update(application_params)
        render json: application, status: :ok
      else
        render json: { errors: application.errors }, status: :unprocessable_entity
      end
    end

    def create
      @application = Application.new(application_params)
      @application.token = generate_unique_token
      if @application.save
        render json: { token: @application.token }, status: :created
      else
        render json: @application.errors, status: :unprocessable_entity
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
  