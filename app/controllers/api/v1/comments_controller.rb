class Api::V1::CommentsController < ApplicationController
  before_action :find_commentable

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

  def show
    @comment = Comment.find(params[:id])

    unless @comment.present?
      render json: { error: "Unable to find comment" }, status: :not_found
      return
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