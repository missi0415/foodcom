class UserSerializer < ActiveModel::Serializer
  attributes :id,:name ,:uid
  has_many :posts
  has_many :comments
end
