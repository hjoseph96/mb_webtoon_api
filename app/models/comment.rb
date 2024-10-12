class Comment < ApplicationRecord
  belongs_to :user

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  has_one_attached :attachment

  validates :attachment, content_type: /\Aimage\/.*\z/
end
