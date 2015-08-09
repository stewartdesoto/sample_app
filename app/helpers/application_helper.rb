module ApplicationHelper
#returns the full title on a per-page basis
	def full_title(page_title = '')
		title = "Rails Tutorial"
		title = page_title + " | " + title unless page_title.empty?
		title
	end
end