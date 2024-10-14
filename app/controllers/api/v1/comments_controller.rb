class Api::V1::CommentsController < ApplicationController
  before_action :find_commentable, only: :create
  before_action :require_login, only: :vote

  api :POST, '/v1/comments'
  param :comment, Hash, desc: 'Key name for comment params', required: true do
    param :user_id, Integer, desc: 'ID of the user making the comment', required: true
    param :body, String, desc: 'Comment text body', required: true
    param :attachment, File, desc: 'Image attachment. Can be gif, png, jpg, jpeg', required: true
  end
  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      render json: @comment
    else
      render json: {
        error: "Error leaving comment: #{@comment.errors.full_messages.join(', ')}"
      }, status: :unprocessable_content
    end
  end

  api :GET, '/v1/comments/:id'
  param :id, Integer, desc: 'ID of the comment in the URL', required: true
  def show
    @comment = Comment.find(params[:id])

    unless @comment.present?
      render json: { error: "Unable to find comment" }, status: :not_found
      return
    end

    render json: @comment
  end

  api :POST, '/v1/comments/:id/vote'
  param :id, Integer, desc: 'ID of the chapter in the URL', required: true
  param :like_type, String, desc: 'Must be "upvote" or "downvote"', required: true
  def vote
    @comment = Comment.find(params[:id])

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
      if current_user.voted_up_on? @comment
        @comment.unliked_by current_user
      else
        @comment.liked_by current_user
      end
    when 'downvote'
      if current_user.voted_down_on? @comment
        @comment.undisliked_by current_user
      else
        @comment.downvote_from current_user
      end
    else
      raise StandardError.new("Somehow, we have an invalid like_type...")
    end

    render json: @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :attachment)
  end

  def find_commentable
    @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
    @commentable = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end
end