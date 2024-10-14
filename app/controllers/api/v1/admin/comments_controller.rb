class Api::V1::Admin::CommentsController < ApplicationController
  before_action :require_admin

  api :DELETE, '/v1/admin/comments/:id/'
  description 'Delete a comment (admin only).'
  param :id, String, desc: 'ID of the comment in the URL', required: true
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