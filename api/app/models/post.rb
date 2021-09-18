class Post < ApplicationRecord
  belongs_to :user
  has_many :like_posts    , dependent: :destroy
  mount_uploader :image, ImageUploader
  has_many :notifications, dependent: :destroy
  
  validates :content, presence: true

  # notification
  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id:    id,
        visited_id: user_id,
        action:     'like'
      )
      if notification.visitor_id == notification.visited_id
        return
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, visited_id)
    notification = current_user.active_notifications.new(
      post_id:    id        ,
      visited_id: visited_id,
      action:     'comment'
    )
    notification.save if notification.valid?
  end
end
