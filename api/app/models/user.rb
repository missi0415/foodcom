require "validator/email_validator"
class User < ApplicationRecord
  has_many :posts         , dependent: :destroy
  has_many :like_posts    , dependent: :destroy
  
  # carrier wave
  mount_uploader :avatar, AvatarUploader
  mount_uploader :header, HeaderUploader

  # 通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # フォロー機能
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy 
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人(自分がフォローされている人)

  def follow(other_user)
    following_user << other_user
  end

  def unfollow(other_user)
    follower.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_user.include?(other_user)
  end

  def followers?(other_user)
    follower_user.include?(other_user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

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
  validates :introduction, length: { maximum: 140 }

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

  def self.search(keyword)
    where(["name like? OR introduction like?", "%#{keyword}%", "%#{keyword}%"])
  end
  
  private
    #email小文字化のメソッド
    def downcase_email
      self.email.downcase! if email
    end

end
