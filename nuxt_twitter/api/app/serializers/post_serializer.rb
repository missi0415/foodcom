class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :content, :created_at,:image, :user
  belongs_to :user
  has_many :comments
  has_many :comments, through: :comments
  has_many :like_posts

  def comments
    object.comments.where(comment_id: 0).order(id: :desc)
  end
end
