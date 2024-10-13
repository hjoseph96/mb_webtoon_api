class ChapterSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :number, :title, :thumbnail_url, :comic_image_url, :created_at

  has_many :comments

  def thumbnail_url
    cdn_for(object.thumbnail)
  end

  def comic_image_url
    cdn_for(object.comic_image)
  end
end
