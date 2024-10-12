class Chapter < ApplicationRecord
  has_many :comments, as: :commentable

  has_one_attached :thumbnail
  has_one_attached :comic_image
end
