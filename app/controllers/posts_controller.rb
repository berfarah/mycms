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

  def set_post_type
    @type = post_type
  end

  def post_type
    params[:type] || "Post"
  end

  def post_type_class
    post_type.constantize
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "#{post_type} was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "#{post_type} was successfully saved." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
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

    def correct_user
      post_type = post_type.downcase

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
      params.require(post_required).permit(:user_id, :date, :title, :summary, :content, :slug, :type)
    end
end
