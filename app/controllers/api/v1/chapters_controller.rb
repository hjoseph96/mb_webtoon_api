class Api::V1::ChaptersController < ApplicationController
  include Pagy::Backend

  def index
    page = params[:page] || 1

    @chapters = pagy(@chapters, page: page).last

    render json: @chapters
  end

  def show
    @chapter = Chapter.find(params[:id])

    render json: @chapter
  end
end