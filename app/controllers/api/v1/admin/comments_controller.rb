class Api::V1::Admin::CommentsController < ApplicationController


  api :POST, '/v1/admin/comments/:id/'
  description 'Delete a comment (admin only).'
  param :id, Integer, desc: 'ID of the comment in the URL', required: true
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