require "validator/email_validator"
class User < ApplicationRecord
  has_many :posts         , dependent: :destroy
  has_many :comments      , dependent: :destroy
  has_many :like_posts    , dependent: :destroy
  has_many :like_comments , dependent: :destroy

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 被フォロー関係を通じて参照→followed_idをフォローしている人

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 【class_name: "Relationship"】は省略可能
  has_many :followings, through: :relationships, source: :followed
  # 与フォロー関係を通じて参照→follower_idをフォローしている人
  
  #フォロー機能
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    followings.include?(user)
  end
  #フォロー機能　ここまで


  # emailを検証時は小文字にする
  before_validation :downcase_email

  # validates
  validates :name, presence: true,
                   length: { maximum: 30, allow_blank: true }
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  # email
  validates :email, presence: true,
                    email: { allow_blank: true }
  validates :uid,  presence: true

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_activated(email)
      find_by(email: email, is_active: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_activated(email).present?
  end
  
  private
    #email小文字化のメソッド
    def downcase_email
      self.email.downcase! if email
    end

end
