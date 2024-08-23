class PlantsController < ApplicationController
  before_action :authenticate_user!
  def index
    @plants = Plant.all
    render :index
  end

  def show
    @plant = Plant.find(params[:id])
    render :show
  end

  def create
    Rails.logger.debug "Incoming params: #{params.inspect}"
    @plant = Plant.new(plant_params)
    @plant.image.attach(params[:image]) unless params[:image] == 'null'
    Rails.logger.info "Permitted parameters: #{plant_params.inspect}"
    if @plant.save
      render :show
    else
      render json: {errors: @plant.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @plant = Plant.find(params[:id])
    @plant.update(plant_params)
    if @plant.save
      :show
    else
      render json: { errors: @plant.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    plant = Plant.find(params[:id])

    if plant.delete
      title = plant.title || "Plant"
      render json: {Message: "#{title} has been removed"}

      else
        render json: {Error: plant.errors.full_messages}, status: :bad_request
    end

  end

  private
    def plant_params
      params.permit(:user_id, :plant_journal_id, :title, :dislikes, :water_frequency, :temperature, :sun_light_exposure, :likes, :description, :image).tap do |whitelisted|
        whitelisted.delete(:image) if params[:image] == "null"
      end
    end

end
