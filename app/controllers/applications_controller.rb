class ApplicationsController < ApplicationController
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
  