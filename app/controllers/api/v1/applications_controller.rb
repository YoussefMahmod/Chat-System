class Api::V1::ApplicationsController < ApplicationController
  # GET /api/v1/applications
  def index
    @apps = Application.all
    render json: @apps
  end

  # GET /api/v1/applications/:token
  def show
    @app = Application.find_by!(app_token: params[:token])
    if !@app.present?
      render json: { error: "Application not found" }, status: :not_found
    else
      render json: @app
    end
  end

  # POST /api/v1/applications
  def create
    @app = Application.new(app_name: params[:name], app_token: SecureRandom.uuid)
    if @app.save
      render json: @app, status: :created
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/applications/:token
  def update
    @app = Application.find_by!(app_token: params[:token])
    if @app.update(app_name: params[:name])
      render json: @app, status: :ok
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end


  # DELETE /api/v1/applications/:token
  def destroy
    @app = Application.find_by!(app_token: params[:token])
    if @app.destroy
      render json: { message: "Application deleted" }, status: :ok
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end
  
  def app_params
    params.require(:application).permit(:token , :name)
  end
  
end
