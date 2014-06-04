class TagsController < ApplicationController
	def index
		if params[:id]
			@tags = Tag.find_by_id(params[:id])
		else
			@tags = Tag.order('name').finder(params[:q]).limit(params[:per])
		end
		respond_to do |format|
			format.html
			format.json { render json: @tags }
		end
	end

	def new
		@tag = Tag.new
	end

	def create
		@tag = Tag.new(tag_params)
		if @tag.save
			redirect_to @tag
		else
			render :new
		end
	end

	def destroy
	end

	private
		def tag_params
			params.require(:tag).permit(:name, :description, :slug)
		end
end