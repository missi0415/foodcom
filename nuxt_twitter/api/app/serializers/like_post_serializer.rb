class LikePostSerializer < ActiveModel::Serializer
  # attributes :id ,:user ,:post
  attributes %i[id user_id post_id]
  belongs_to :user
  belongs_to :post
end
