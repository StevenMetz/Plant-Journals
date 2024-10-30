class Users::ProfileController < ApplicationController

  def show
    @user = User.find_by(id: current_user.id)
    render :show, as: :json

  end
end
