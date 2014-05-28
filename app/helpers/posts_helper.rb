module PostsHelper
	def sti_post_path(post_type = "post", post = nil, action = nil)
		send "#{format_sti(action, post_type, post)}_path", post
	end

	def format_sti(action, post_type, post)
		action || post ? "#{format_action(action)}#{post_type.underscore}" : "#{post_type.underscore}_index"
	end

	def format_action(action)
		action ? "#{action}_" : ""
	end
end
