class PostsController < ApplicationController
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :is_user_post ,only: [:edit, :update, :destroy]
  def index
    @posts = Post.published
  end

  def user_posts
    @posts = Post.where(user_id: current_user.id)
  end

  def show
    @is_user_post = !current_user.nil? && @post.user_id == current_user.id
  end
  def new
    @post = Post.new
    @post.user_id = current_user.id
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def is_user_post
    if current_user.nil? || @post.user_id != current_user.id
      respond_to do |format|
        format.html {redirect_to posts_url, alert: "Forbidden delete or edit posts of another user"}
        format.json { head :forbidden}
      end
    end
  end

  def set_blog_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :published_at)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

end
