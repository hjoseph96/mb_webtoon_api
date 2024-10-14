class Api::V1::ChaptersController < ApplicationController
  include Pagy::Backend

  before_action :require_login, only: :vote

  api :GET, '/v1/chapters'
  param :page, Integer, desc: 'page param for pagination. must be >= 1', required: true
  def index
    page = params[:page] || 1

    @chapters = pagy(Chapter.all, page: page).last

    render json: @chapters
  end

  api :GET, '/v1/chapters/:id'
  param :id, Integer, desc: 'ID of the chapter in the URL', required: true
  def show
    @chapter = Chapter.find(params[:id])

    render json: @chapter
  end

  api :POST, '/v1/chapters/:id/vote'
  param :id, Integer, desc: 'ID of the chapter in the URL', required: true
  param :like_type, String, desc: 'Must be "upvote" or "downvote"', required: true
  def vote
    @chapter = Chapter.find(params[:id])

    unless params[:like_type].present?
      render json: { error: 'Missing param: like_type' }, status: :bad_request
      return
    end

    unless %w(upvote downvote).include?(params[:like_type])
      render json: { error: 'Invalid like_type: must be "upvote" or "downvote"' }, status: :bad_request
      return
    end

    case params[:like_type]
    when 'upvote'
      if current_user.voted_up_on? @chapter
        @chapter.unliked_by current_user
      else
        @chapter.liked_by current_user
      end
    when 'downvote'
      if current_user.voted_down_on? @chapter
        @chapter.undisliked_by current_user
      else
        @chapter.downvote_from current_user
      end
    else
      raise StandardError.new("Somehow, we have an invalid like_type...")
    end

    render json: @chapter
  end
end