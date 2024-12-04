class PlantJournalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @plant_journals = current_user.plant_journals
    render :index
  end

  def show
    @plant_journal = PlantJournal.find_by(id: params[:id])

    # Check if user has access to this journal (either owns it or it's shared with them)
    if @plant_journal && (current_user.plant_journals.include?(@plant_journal) ||
                          SharedJournal.exists?(user_id: current_user.id, plant_journal_id: @plant_journal.id))
      render :show
    else
      render json: { message: "Plant Journal not found" }, status: :not_found
    end
  end

  def create
    @plant_journal = PlantJournal.new(plant_params.merge(user_id: current_user.id))

    if @plant_journal.save
      render :show, status: :created
    else
      render json: {
        message: "Plant Journal couldn't be created",
        Error: @plant_journal.errors.full_messages.to_sentence,
      }, status: :unprocessable_entity
    end
  end

  def share_journal
    @journal = current_user.plant_journals.find_by(id: params[:id])
    unless @journal
      render json: { message: 'Journal not found' }, status: :not_found
      return
    end

    begin
      user = User.find_by(email: params[:email])
      unless user
        render json: { message: 'User not found' }, status: :not_found
        return
      end


      if SharedJournal.exists?(user_id: user.id, plant_journal_id: @journal.id)
        render json: { message: "#{@journal.title} is already shared with #{user.name}" }, status: :unprocessable_entity
        return
      end

      ActiveRecord::Base.transaction do
        shared_journal = SharedJournal.create(user_id: user.id, plant_journal_id: @journal.id)

        if shared_journal.save
          notification = Notification.create(
            user_id: user.id,
            title: "New plant journal was shared with you.",
            message: "#{current_user.name} shared #{@journal.title} with you"
          )

          if notification.save
            render json: {
              message: "#{current_user.name} has successfully shared their journal with #{user.name}",
              notification: notification
            }, status: :ok
          else
            render json: {
              message: "Unable to send notification",
              errors: notification.errors.full_messages
            }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
          UserMailer.shared_journal_email(current_user,user,@journal.title).deliver_now
        else
          Rails.logger.error "SharedJournal save failed: #{shared_journal.errors.full_messages}"
          render json: {
            message: 'Unable to share journal',
            errors: shared_journal.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

    rescue StandardError => e
      render json: {
        message: 'An error occurred while sharing the journal',
        error: e.message
      }, status: :internal_server_error
    end
  end

  def destroy_plant
    plant_journal = current_user.plant_journals.find_by(id: params[:plant_journal_id])
    plant = Plant.find_by(id: params[:id])

    unless plant_journal && plant
      render json: { message: "Plant or journal not found" }, status: :not_found
      return
    end

    if plant_journal.plants.include?(plant)
      # Remove the association instead of setting plant_journal_id to nil
      if plant_journal.plants.delete(plant)
        render json: {
          message: "#{plant.title} has been removed from your journal",
          plants: plant_journal.plants
        }, status: :ok
      else
        render json: {
          message: "#{plant.title} couldn't be removed from your journal",
          errors: plant.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: { message: "Plant not found in this journal" }, status: :unprocessable_entity
    end
  end

  def destroy
    plant_journal = current_user.plant_journals.find_by(id: params[:id])

    if plant_journal
      # Remove all plant associations before destroying
      plant_journal.plants.clear
      plant_journal.destroy
      render json: { message: "Plant Journal #{plant_journal.title} has been deleted" }, status: :ok
    else
      render json: {
        message: "Couldn't delete Plant Journal",
        Error: "Plant journal not found or unauthorized"
      }, status: :not_found
    end
  end

  private

    def plant_params
      params.permit(:title, plant_ids: [])
    end
end
