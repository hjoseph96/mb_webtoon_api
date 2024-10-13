class Api::V1::Admin::CommentsController < ApplicationController
  def destroy
    @comment = Comment.find(params[:id])

    if @comment.present?
      @comment.destroy

      render json: { success: true, message: 'Comment deleted' }
    else
      render json: { error: 'No comment found' }, status: :not_found
    end
  end
end