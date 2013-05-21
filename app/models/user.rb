require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  # attr_accessible :title, :body
  #has_many :completed_quizzes TODO
  attr_accessor :password_raw

  validates_presence_of :password_raw, :if => :password_required?
  validates_confirmation_of :password_raw, :if => :password_required?
  validates_presence_of :password_raw_confirmation, :if => :password_required?
  MIN_PASSWORD_LENGTH = 5
  MAX_PASSWORD_LENGTH = 128
  validates_length_of :password_raw, :within => MIN_PASSWORD_LENGTH..MAX_PASSWORD_LENGTH, :if => :password_required?

  validates_presence_of :email
  MIN_EMAIL_LENGTH = 5
  MAX_EMAIL_LENGTH = 128
  EMAIL_REGEX = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
  validates_length_of :email, :within => MIN_EMAIL_LENGTH..MAX_EMAIL_LENGTH
  validates_format_of :email, :with => EMAIL_REGEX, :message => "is invalid"

  def password_required?
    self.encrypted_password.blank? || !password_raw.blank?
  end

  def self.email_available?(email)
    self.where("email = ?", email).count == 0
  end

  before_save :encrypt_password_raw

  # before filter
  def encrypt_password_raw
    return if password_raw.blank?
    self.salt = BCrypt::Engine.generate_salt
    self.encrypted_password= BCrypt::Engine.hash_secret(password_raw, salt)
    self.password_raw = nil
    self.password_raw_confirmation = nil
    return nil
  end

  def authenticate(user, password)
    user.authenticate_with_password(password)
  end

  def authenticate_with_password(password)
    encrypted_password == BCrypt::Engine.hash_secret(password, salt)
  end
end
