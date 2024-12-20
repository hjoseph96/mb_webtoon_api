class Chapter < ApplicationRecord
  acts_as_votable

  has_many :pages
  accepts_nested_attributes_for :pages

  has_many :comments, as: :commentable

  has_one_attached :thumbnail
  has_one_attached :comic_image

  validates :number, uniqueness: true
  validates :title, uniqueness: true
  validates :thumbnail, content_type: /\Aimage\/.*\z/
  validates :comic_image, content_type: /\Aimage\/.*\z/

end
