module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	# remembers a user in a permanent session as follows:
	# creates random characters as remember token, stores digest in database
	# stores encrypted user id in permanent cookie (20yr) in user's browser
	# stores unencrypted remember token as permanent cookie
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def current_user
		if (user_id = session[:user_id]) # assignment, not comparison
			@current_user ||= User.find_by(id: user_id)	
		elsif (user_id = cookies.signed[:user_id]) # permanently signed in
			#raise # this branch is not tested, so we don't get here
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def logged_in?
		!current_user.nil?
	end

	#forgets a persistent session by removing remember_token digest from database
	# and deleting permanent cookies
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
end
