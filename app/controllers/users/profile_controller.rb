class Users::ProfileController < ApplicationController

  def show
    @user = User.find_by(id: current_user.id)
    render :show, as: :json

  end
  def update_user
    @user = User.find_by(id: current_user.id)
    if current_user.id == @user.id
      @user.image.attach(params[:image]) unless params[:image] == 'null'
      @user.banner.attach(params[:banner]) unless params[:banner] == 'null'
      Rails.logger.info (" Params from user Update#{params}")
      @user.update(user_params)
      if @user.save
        # respond_with(@user, message: 'Succesfully Updated User')
        render :show, as: :json
      else
        render json: { message: "User couldn't be updated succesfully.", error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized to update this user" }, status: :unauthorized
    end
  end
  def user_params
    params.require(:user).permit(:name, :email, :image, :banner)
  end
end
