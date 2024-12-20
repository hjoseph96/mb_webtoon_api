class Api::V1::Admin::ChaptersController < ApplicationController
  before_action :require_admin

  def index
  end

  api :POST, '/v1/admin/chapters'
  description 'Chapter upload endpoint (admin only)'
  param :chapter, Hash, desc: 'Key name for chapter params', required: true do
    param :title, String, desc: 'Unique (available) title for chapter', required: true
    param :number, String, desc: 'The chapter number, must be unique (available)', required: true
    param :thumbnail, ActionDispatch::Http::UploadedFile, desc: "Preview thumbnail for the chapter. Must be an image", required: true
    param :pages_attributes, Hash, desc: "The vertical scrolling comic image.", required: true do
      param :image,  ActionDispatch::Http::UploadedFile, required: false
      param :order, String, required: false
    end
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
      :title, :number, :thumbnail, pages_attributes: [:image, :order]
    )
  end
end