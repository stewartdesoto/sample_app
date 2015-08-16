require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user=User.create!(name: 'Example User', 
			email: 'user@example.com',
			password: "okay123",
			password_confirmation: "okay123")
	end

	test "user should be valid" do
		assert @user.valid?
	end

	test "user name should be present" do
		@user.name = "     "
		assert_not @user.valid?
	end

	test "user email should be present" do
		@user.email = "     "
		assert_not @user.valid?
	end

	test "user name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "user email should not be too long" do
		@user.email = "a" * 251
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses=%w(user@example.com ME234@y.edu)
		valid_addresses.each do |address|
			@user.update_attributes(email: address)
			assert @user.valid?, "#{address} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses=%w(rtrt foot@bar.bar.bar+ 12@12)
		invalid_addresses.each do |address|
			@user.update_attributes(email: address)
			assert_not @user.valid?, "#{address} should be invalid"
		end
	end

	test "email address should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = duplicate_user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with a nil digest" do
		assert_not @user.authenticated?('')
	end
end
