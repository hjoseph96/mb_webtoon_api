class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  api :POST, '/v1/users'
  description 'User signup endpoint. Return JSON Web Token for Authorization header.'
  param :user, Hash, desc: 'Key name for user params', required: true do
    param :username, String, desc: 'Unique (available) username for user', required: true
    param :email, String, desc: 'Unique (available) email for user', required: true
    param :password, String, desc: "User's password", required: true
    param :password_confirmation, String, desc: "User's password confirmation (ensure they match)", required: true
  end
  def create
    @user = User.new(user_params)

    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: UserSerializer.new(@user), token: token }
    else
      render json: {
        error: "Error creating user: #{@user.errors.full_messages.join(', ')}"
      }, status: :unprocessable_content
    end
  end

  api :POST, '/v1/users'
  description 'User update endpoint. For updating username, email, and password + uploading avatar.'
  param :id, String, desc: 'ID of the comment in the URL', required: true
  param :user, Hash, desc: 'Key name for user params', required: true do
    param :username, String, desc: 'Unique (available) username for user'
    param :email, String, desc: 'Unique (available) email for user'
    param :password, String, desc: "User's password"
    param :password_confirmation, String, desc: "User's password confirmation (ensure they match)"
    param :avatar, ActionDispatch::Http::UploadedFile, desc: "User's password confirmation (ensure they match)"
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