class LikeCommentSerializer < ActiveModel::Serializer
  attributes :id ,:user, :comment
  belongs_to :user
  belongs_to :comment
end
