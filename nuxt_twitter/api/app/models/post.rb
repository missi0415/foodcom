class Post < ApplicationRecord
  belongs_to :user

  belongs_to :post_id
  has_many :comments , dependent: :destroy

  has_many :like_posts    , dependent: :destroy
  #画像投稿
  mount_uploader :image, ImageUploader
  
  validates :content, presence: true
end
