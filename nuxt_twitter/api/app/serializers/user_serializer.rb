class UserSerializer < ActiveModel::Serializer
  attributes :id,:name,:introduction, :avatar
  has_many :posts
  has_many :comments
  has_many :like_posts
  has_many :like_comments
  # has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # ① フォローしている人取得(Userのfollowerから見た関係)
  has_many :following_user
  # has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # ② フォローされている人取得(Userのfolowedから見た関係)
  has_many :follower_user
end
