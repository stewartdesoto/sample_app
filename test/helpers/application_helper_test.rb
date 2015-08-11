require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full_title helper test" do
		assert_equal full_title, "Rails Tutorial"
		assert_equal full_title("Help"), "Help | Rails Tutorial"
	end
end
