class LikePostSerializer < ActiveModel::Serializer
  attributes :id ,:user ,:post
  belongs_to :user
  belongs_to :post
end
