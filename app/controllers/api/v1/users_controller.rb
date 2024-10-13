class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { success: true, user: @user }
    else
      render json: {
        error: "Error creating user: #{@user.errors.full_messages.join(', ')}"
      }, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end