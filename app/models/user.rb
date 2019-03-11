class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  validates :email, presence: true,
    length: {maximum: Settings.max_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.min_password_length},
    allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.max_name_length}

  before_save {self.email = email.downcase}

  scope :order_by_name, ->{order "name ASC"}

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def current_user? current_user
    self == current_user
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?(remember_token)
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest) == remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  has_secure_password
end
