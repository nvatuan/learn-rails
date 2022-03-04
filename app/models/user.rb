class User < ApplicationRecord
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

  private

  has_secure_password

  def email_downcase
    email.downcase!
  end
end
