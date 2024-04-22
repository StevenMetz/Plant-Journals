class PlantJournalsController < ApplicationController
  before_action :authenticate_user!
  def show
    @plant_journal = PlantJournal.find_by(user_id: current_user.id)
    render :show
  end

  def create
    plant_journal = PlantJournal.create(plant_params)

    if plant_journal.save && current_user
      render :show
    else
      render json: {message: "Plant Journal couldn't be created",
      Error: plant_journal.errors.full_messages.to_sentence,
      }, status: :unprocessable_entity
    end
  end

  def destroy_plant
    plant = current_user.plants.find_by(id: params[:id])

    if plant
      if plant.update(plant_journal_id: nil)
        render json: { message: "#{plant.title} has been removed from your journal" }, status: :ok
      else
        render json: { message: "#{plant.title} couldn't be removed from your journal",
                      errors: plant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Plant not found or unauthorized to delete" }, status: :unprocessable_entity
    end
  end
  def destroy
    plant_journal = PlantJournal.find_by(user_id: current_user.id)

    if plant_journal && current_user
      plant_journal.destroy
      render json: {message: "Plant Journal #{plant_journal.title} has been deleted"}, status: :ok
    else
      render json: {message: "Couldn't delete Plant Journal", Error: plant_journal.errors.full_messages.to_sentence}
    end
  end

  private
    def plant_params
      params.permit(:user_id,:title)
    end
end
