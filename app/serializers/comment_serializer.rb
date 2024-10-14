class CommentSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :body, :user_id, :attachment_url,
             :upvotes, :downvotes, :total_votes, :commentable_type, :commentable_id

  has_many :comments

  def attachment_url
    return nil unless object.attachment.present?

    cdn_for(object.attachment)
  end

  def upvotes
    object.cached_votes_up
  end

  def downvotes
    object.cached_votes_down
  end

  def total_votes
    object.cached_votes_total
  end
end
