class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc)
    render :index, status: :ok
  end

  def create
    @notification = Notification.create!(notification_params)
    if @notification.save
      render :show, status: :created
    else
      render json: {message: "Unable to make notification", errors: @notifcation.errors}
    end
  end

  def update
    @notification = Notification.find_by(id: params[:id])

    if @notification
      if @notification.update(notification_params)
        # Return all notifications, sorted by created_at
        @notifications = Notification.order(created_at: :desc)
        render :index
      else
        render json: { message: "Unable to update notification", errors: @notification.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: "Notification not found" }, status: :not_found
    end
  end

  def destroy
    notification = Notification.find_by(id: params[:id])
    if notification.nil?
      render json: { message: "Unable to delete notification: Notification not found" }, status: :unprocessable_entity
      return
    end

    if notification.destroy()
      render json: {message: "Notification Removed"}, status: :ok
    else
      render json: {message: "Unable to delete notification"}, status: :unprocessable_entity
    end

  end

  private

    def notification_params
      params.permit(:user_id,:viewed,:notification_type, :message, :title)
    end
end
