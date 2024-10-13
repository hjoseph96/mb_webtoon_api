class Api::V1::SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def create
    @user = User.find_for_database_authentication(login: user_params[:login])

    return invalid_login_attempt unless @user.present?

    if @user.valid_password?(user_params[:password])
      sign_in("user", @user)
      render json: @user
      return
    end

    invalid_login_attempt
  end

  def destroy
    @user = User.find(params[:user_id])

    if sign_out(@user)
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_content
    end
  end

  protected

  def invalid_login_attempt
    render(json: { success: false, message: "Error with your login or password" }, status: :unprocessable_content)
  end

  private
  def user_params
    params.permit(:login, :password)
  end
end