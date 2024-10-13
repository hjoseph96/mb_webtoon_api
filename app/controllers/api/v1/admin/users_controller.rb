class Api::V1::Admin::UsersController < ApplicationController
  include Pagy::Backend

  before_action :require_admin

  def index
    page = params[:page] || 1

    @users = pagy(User.all, page: page).last

    render json: @users
  end
end