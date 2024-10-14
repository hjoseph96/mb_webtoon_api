class Api::V1::Admin::UsersController < ApplicationController
  include Pagy::Backend

  before_action :require_admin

  api :GET, '/v1/admin/users'
  description 'List all users (admin only)'
  param :page, Integer, desc: 'page param for pagination. must be >= 1', required: true
  def index
    page = params[:page] || 1

    @users = pagy(User.all, page: page).last

    render json: @users
  end
end