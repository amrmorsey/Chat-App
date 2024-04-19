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
  
    private
  
    def application_params
      params.require(:application).permit(:name)
    end

    def generate_unique_token
      loop do
        token = SecureRandom.hex(10) # Generate a random hex token
        break token unless Application.exists?(token: token)
      end
    end

  end
  