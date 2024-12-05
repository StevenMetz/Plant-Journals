class FeedbackController < ApplicationController
  def index
    @feedbacks = Feedback.all
    render :index
  end

  def show
    @feedback = Feedback.find_by(id: params[:id])
    render :show
  end
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      render json: {message: "Feedback created"}, status: :created
    else
      render json: {message: "Error submiting feedback", errors: @feedback.errors.full_messages.to_sentence}
    end
  end
  def update
    @feedback = Feedback.find_by(id: params[:id])

    if @feedback.update(feedback_params)
      render json: {message: "Feedback updated"}, status: :ok
    else
      render json: {message: "Error updating feedback", errors: @feedback.errors.full_messages.to_sentence}
    end
  end

  def destroy
    feedback = Feedback.find_by(id: params[:id])

    if feedback
      if feedback.destroy
        render json: {message: "Feedback successfully removed"}, status: :ok
      else
        render json: {message: "Error removing feedback", errors: feedback.errors.full_messages.to_sentence}, status: :unprocessable_entity
      end
    else
      render json: {message: "Feedback not found"}, status: :not_found
    end
  end

  private
    def feedback_params
      params.permit(:user_id, :message, :rating)
    end
end
