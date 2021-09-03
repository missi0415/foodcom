class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :content, :post_id, :created_at, :image, :user
  belongs_to :user
  has_many :like_posts

end
