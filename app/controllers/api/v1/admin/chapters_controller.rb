class Api::V1::Admin::ChaptersController < ApplicationController
  before_action :require_admin

  def index
  end
  def create
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      render json: @chapter
    else
      render json: {
        error: "Error creating chapter: #{@chapter.errors.full_messages.join(', ')}"
      }
    end
  end

  private

  def chapter_params
    params.require(:chapter).permit(
      :title, :number, :thumbnail, :comic_image
    )
  end
end