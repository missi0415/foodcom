class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_id, :content, :created_at, :comment_id, :like_comments

  belongs_to :user
  belongs_to :post
  has_many   :like_comments
end
