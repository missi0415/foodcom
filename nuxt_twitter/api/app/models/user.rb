require "validator/email_validator"
class User < ApplicationRecord
  # emailを検証時は小文字にする
  before_validation :downcase_email

  # gem bcrypt
  has_secure_password
  # validates
  validates :name, presence: true,
                   length: { maximum: 30, allow_blank: true }
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: { minimum: 8 },
                       format: {
                        with: VALID_PASSWORD_REGEX,
                        message: :invalid_password 
                       },
                       allow_nil: true
  # email
  validates :email, presence: true,
                    email: { allow_blank: true }

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_activated(email)
      find_by(email: email, activated: true)
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