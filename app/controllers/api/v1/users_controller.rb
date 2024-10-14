class Api::V1::UsersController < ApplicationController

  api :POST, '/v1/users'
  description 'User signup endpoint'
  param :comment, Hash, desc: 'Key name for comment params', required: true do
    param :username, String, desc: 'Unique (available) username for user', required: true
    param :email, String, desc: 'Unique (available) email for user', required: true
    param :password, String, desc: "User's password", required: true
    param :password_confirmation, String, desc: "User's password confirmation (ensure they match)", required: true
  end
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render json: {
        error: "Error creating user: #{@user.errors.full_messages.join(', ')}"
      }, status: :unprocessable_content
    end
  end

  def update
    @user = User.find(params[:id])

    unless @user.present?
      render json: { error: "User with id: #{params[:id]} not found" }
      return
    end

    if @user.update(user_params)
      render json: @user
    else
      render json: {
        error: "Error updating user: #{@user.errors.full_messages.join(', ')}"
      }, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :avatar)
  end
end