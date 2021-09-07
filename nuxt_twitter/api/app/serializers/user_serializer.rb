class UserSerializer < ActiveModel::Serializer
  attributes :id,:name, :avatar ,:header, :email,:introduction,:is_active, :admin , :like_posts 
  has_many :posts
  has_many :like_posts
  has_many :following_user
  has_many :follower_user

end
