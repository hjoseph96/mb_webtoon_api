class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    render json: @user if @user.save!
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end