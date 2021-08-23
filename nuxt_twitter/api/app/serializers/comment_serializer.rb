class CommentSerializer < ActiveModel::Serializer
  attributes :id, :like_comment, :like_post, :notification, :relationship
end
