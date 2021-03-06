require 'bcrypt'

class User
	include Mongoid::Document
	attr_accessor :password

  has_many :workouts
  has_many :entries
  has_many :exercises

  field :username, type: String
  field :salt, type: String
  field :hashed_password, type: String

  validates :username, :presence => true, :uniqueness => true
  validates :password, :presence => true
  
  def authenticated? pwd
  	self.hashed_password == BCrypt::Engine.hash_secret(pwd, self.salt)
  end

  before_save :hash_stuff
  # downcase users for login purposes
  # before_save { self.username = username.downcase }

  private

  def hash_stuff
  	self.salt = BCrypt::Engine.generate_salt
  	self.hashed_password = BCrypt::Engine.hash_secret self.password, self.salt
  	self.password = nil
  end
end
