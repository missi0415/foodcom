class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :followed_id, :follower_id
  belongs_to :follower, serializer: UserSerializer
  belongs_to :followed, serializer: UserSerializer
end
