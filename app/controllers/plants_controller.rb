class PlantsController < ApplicationController
  def index
    @plants = Plant.all
    render :index
  end

  def show
    @plant = Plant.find(params[:id])
    render :show
  end

  def create
    plant = Plant.new(plant_params)

    if plant.save
      render :show

    else
      render json: {errors: plant.errors.full_messages}, status: :bad_request
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

      render json: {Message: "Plant has been deleted"}

      else
        render json: {Error: plant.errors.full_messages}, status: :bad_request
    end

  end

  private
    def plant_params
      params.permit(:title, :description, :likes, :dislikes, :water_frequency, :temperature, :sun_light_exposure, :user_id, :plant_journal_id)
    end


end
