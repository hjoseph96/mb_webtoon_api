class ChapterSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :number, :title, :thumbnail_url,
             :upvotes, :downvotes, :total_votes, :created_at

  has_many :pages
  has_many :comments

  def thumbnail_url
    cdn_for(object.thumbnail)
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
