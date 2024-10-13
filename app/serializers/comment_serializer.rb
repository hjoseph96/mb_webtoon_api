class CommentSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :body, :user_id, :attachment_url, :commentable_type, :commentable_id

  has_many :comments

  def attachment_url
    return nil unless object.attachment.present?

    cdn_for(object.attachment)
  end
end
