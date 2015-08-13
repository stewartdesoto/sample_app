require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	test "invalid signup rejection" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: {
				name: "",
				email: "joe",
				password: "sameone",
				password_confirmation: "sameone"
			}
		end
		assert_template 'users/new'
	end

	test "valid signup acceptance" do
		get signup_path
		assert_difference 'User.count',1 do
			post_via_redirect users_path, user: {
				name: "Samuel",
				email: "samuel@yahoo.com",
				password: "sameone",
				password_confirmation: "sameone"
			}
		end
		assert_template 'users/show'
	end
end
