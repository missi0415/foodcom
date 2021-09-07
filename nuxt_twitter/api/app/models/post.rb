class Post < ApplicationRecord
  belongs_to :user
  has_many :like_posts    , dependent: :destroy
  mount_uploader :image, ImageUploader
  
  validates :content, presence: true
end
