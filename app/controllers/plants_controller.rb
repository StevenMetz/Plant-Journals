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
    @plant = Plant.new(plant_params.merge(user_id: current_user.id))
    @plant.image.attach(params[:image]) unless params[:image] == 'null'
    Rails.logger.info "Permitted parameters: #{plant_params.inspect}"
    if @plant.save
      render :show
    else
      render json: {errors: @plant.errors.full_messages}, status: :bad_request
    end
  end

  def update_plant_journal
    ActiveRecord::Base.transaction do
      # Find plant journal and return early if not found
      plant_journal = PlantJournal.find_by(id: params[:id])
      unless plant_journal
        Rails.logger.error("Plant journal not found with id: #{params[:id]}")
        render json: { error: "Plant journal not found" }, status: :not_found
        return
      end

      # Handle different ways the plant_ids might come in
      plant_ids = if params[:plant_ids].is_a?(String)
                    params[:plant_ids].split(',').map(&:to_i)
                  elsif params[:plant_ids].is_a?(Array)
                    params[:plant_ids].map(&:to_i)
                  else
                    []
                  end

      # Validate plant_ids parameter
      if plant_ids.empty?
        Rails.logger.error("Invalid or empty plant_ids parameter")
        render json: { error: "Invalid plant_ids parameter" }, status: :unprocessable_entity
        return
      end

      begin
        updated_plants = []
        failed_plants = []

        # Find and update each plant by ID
        plant_ids.each do |plant_id|
          plant = Plant.find_by(id: plant_id)
          if plant.nil?
            failed_plants << {
              id: plant_id,
              error: "Plant not found"
            }
            Rails.logger.error("Plant not found with id: #{plant_id}")
            next
          end

          if plant.update(plant_journal_id: plant_journal.id)
            updated_plants << plant_id
          else
            failed_plants << {
              id: plant_id,
              errors: plant.errors.full_messages
            }
            Rails.logger.error("Failed to update plant #{plant_id}: #{plant.errors.full_messages}")
          end
        end

        response = {
          message: "Plant journal update completed",
          updated_plants: updated_plants
        }
        response[:failed_plants] = failed_plants if failed_plants.any?

        render json: response, status: :ok

      rescue StandardError => e
        Rails.logger.error("Error updating plant journal: #{e.message}")
        raise ActiveRecord::Rollback
        render json: { error: "Internal server error" }, status: :internal_server_error
        return
      end
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
      params.permit(:plant_journal_id, :title, :dislikes, :water_frequency, :temperature, :sun_light_exposure, :likes, :description, :image).tap do |whitelisted|
        whitelisted.delete(:image) if params[:image] == "null"
      end
    end

end
