class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token, :activation_token

  validates :email, presence: true,
    length: {maximum: Settings.max_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.min_password_length},
    allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.max_name_length}

  before_save :downcase_email
  before_create :create_activation_digest

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

  def authenticated?(attribute, remember_token)
    digest = send("#{attribute}_digest")
    return false if digest.blank?
    BCrypt::Password.new(digest) == remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  has_secure_password

  private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
