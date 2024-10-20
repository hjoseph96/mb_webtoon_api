class PageSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :order, :chapter_id, :image_url

  def image_url
    cdn_for(object.image)
  end
end