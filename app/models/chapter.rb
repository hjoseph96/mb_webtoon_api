class Chapter < ApplicationRecord
  has_many :comments, as: :commentable

  has_one_attached :thumbnail
  has_one_attached :comic_image

  validates :number, uniqueness: true
  validates :title, uniqueness: true
  validates :thumbnail, content_type: /\Aimage\/.*\z/
  validates :comic_image, content_type: /\Aimage\/.*\z/

end
