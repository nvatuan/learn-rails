class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :email_downcase

  validates :name,
            presence: true,
            length: {maximum: Settings.length.username_max_len}
  validates :email,
            presence: true,
            length: {maximum: Settings.length.email_max_len},
            format: {with: Settings.regex.email_regex},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.length.password_min_len}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private
  has_secure_password

  def email_downcase
    email.downcase!
  end
end
