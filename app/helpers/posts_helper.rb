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

	def post_tag(tags = @post.tags, separator = ', ', linksto = true )
		output = []
		tags.each do |tag|
			if linksto
				output << ( link_to tag.name, tag_path(tag) )
			else
				output << tag.name
			end
		end
		self.tags = output.join(separator)
	end
end
