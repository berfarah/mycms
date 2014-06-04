class PostsController < ApplicationController

  include Post::PostsHelper

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post_type

  # GET /posts
  # GET /posts.json
  def index
    @posts = post_type_class.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = post_type_class.find(params[:id])

    if request.path != sti_post_path(post_type, @post)
      redirect_to @post, status: :moved_permanently
    else
      respond_to do |format|
        format.html
        format.json { render json: @post }
      end
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      p = params[:post][:tag_tokens].split(',') - @post.tags.ids
      p.select{ |x| x.present? }.each do |tag_id|
        tagging = Tagging.new(tag_id: tag_id, taggable_id: @post.id, taggable_type: 'Post') if Tag.exists?(tag_id)
        oops = tagging unless tagging.save # Check if saved and throw appropriate errors
      end
    else
      oops = @post # Throw post error
    end

    respond_to do |format| # Redirect or output error
      if oops.blank?
        format.html { redirect_to @post, notice: "#{post_type} was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: oops.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.update(post_params)
      p = params[:post] || params[:shared] || params[:design] || params[:music]

      removed = @post.tags.ids - p[:tag_tokens].split(',')
      added   = p[:tag_tokens].split(',') - @post.tags.ids

      added.each do |tag_id|
        tagging = Tagging.new(tag_id: tag_id, taggable_id: @post.id, taggable_type: 'Post') if Tag.exists?(tag_id)
        oops = tagging unless tagging.save
      end

      removed.each do |tag_id|
        tagging = Tagging.find_by_tag_id_and_taggable_id_and_taggable_type(tag_id, @post.id, 'Post')
        oops = tagging unless tagging.destroy
      end
    else
      oops = @post
    end

    respond_to do |format|
      if oops.blank?
        format.html { redirect_to @post, notice: "#{post_type} was successfully saved." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: '#{post_type} was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = post_type_class.find(params[:id])
    end

    def set_post_type
      @type = post_type
    end

    def post_type
      params[:type] || "Post"
    end

    def post_type_class
      post_type.constantize
    end

    def post_type_param
      ":#{post_type}"
    end

    def post_type_method
      post_type.methodize
    end

    def correct_user
      post_type = post_type.to_s.downcase

      if current_user
        @post = current_user.posts.find(params[:id])
        redirect_to posts_path, notice: "Not authorized to edit this #{post_type}" if @post.nil?
      else
        redirect_to new_user_session_path, notice: "Please log in to edit a #{post_type}"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      post_required = post_type.downcase.to_sym
      params.require(post_required).permit(:user_id, :date, :title, :summary, :content, :slug, :type, :tag_tokens, :tag_ids)
    end
end
