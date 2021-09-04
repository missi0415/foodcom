class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :content, :post_id, :created_at, :image, :user, :comments, :like_posts_count
  belongs_to :user
  has_many :like_posts

  def comments
    Post.where(post_id: object.id)
  end
  def like_posts_count
    object.like_posts.length
  end

end
