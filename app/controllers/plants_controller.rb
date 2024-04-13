class PlantsController < ApplicationController
  def index
    @plants = Plant.all
    render json: @plants.as_json
  end

  def show
    @plant = Plant.find(params[:id])
    render json: @plant.as_json
  end

  def create
    plant = Plant.new(plant_params)

    if plant.save
      render json: plant.as_json

    else
      render json: {errors: plant.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @plant = Plant.find(params[:id])
    @plant.update(plant_params)
    if @plant.save
      render json: @plant
    else
      render json: { errors: @plant.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    plant = Plant.find(params[:id])

    if plant.delete

      render json: {Message: "Plant has been deleted"}

      else
        render json: {Error: plant.errors.full_messages}, status: :bad_request
    end

  end

  private
    def plant_params
      params.permit(:title, :description, :likes, :dislikes, :water_frequency, :temperature, :sun_light_exposure)
    end


end
