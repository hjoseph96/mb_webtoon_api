class Api::V1::ChaptersController < ApplicationController
  include Pagy::Backend

  before_action :require_login, only: :vote

  def index
    page = params[:page] || 1

    @chapters = pagy(@chapters, page: page).last

    render json: @chapters
  end

  def show
    @chapter = Chapter.find(params[:id])

    render json: @chapter
  end

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