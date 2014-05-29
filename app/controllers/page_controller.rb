class PageController < PostsController

	before_action :is_admin, except: [:show, :home]
 	before_action :authenticate_user!, except: [:index, :show, :home]

	def home
	end

	def show
		@post = post_type_class.find_by_slug!(params[:id])
	end

	def page_not_found
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def is_admin
				raise ActiveRecord::RecordNotFound if !current_user || current_user.admin.nil?
		end

		def correct_user
			if current_user
				@post = current_user.posts.find_by_slug(params[:id])
				redirect_to posts_path, notice: "Not authorized to edit this page" if @post.nil?
			else
				redirect_to new_user_session_path, notice: "Please log in to edit a page"
			end
		end
end
