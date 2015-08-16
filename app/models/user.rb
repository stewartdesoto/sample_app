class User < ActiveRecord::Base
	attr_accessor :remember_token

	before_save {self.email = email.downcase}

	validates :name, presence: true,
					length: {maximum: 50}
	
	VALID_EMAIL_REGEX = /\A[\w\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :email, presence: true,
					length: {maximum: 250},
					format: { with: VALID_EMAIL_REGEX},
					uniqueness: {case_sensitive: false}

	validates :password, length: {minimum: 6}
	
	has_secure_password

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? 
			BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# returns a random token, e.g. "2q82-oKDQgv_-L17bquGcg"
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# remembers a user in the database for use in persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))		
	end

	#returns true if the provided token hashes out to match the
	# remember_digest stored in the database
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end
end
