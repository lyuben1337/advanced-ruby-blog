class CommentsController < ApplicationController
  before_action :is_user
  before_action :is_user_comment_or_post, only: [:destroy]
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to post_url(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if current_user.id != @comment.user_id && current_user.id != @post.user_id
      return respond_to do |format|
        format.html {redirect_to post_path(@post), alert: "You cant delete this comment!"}
        format.json { head :forbidden}
      end
    end

    @comment.destroy
    redirect_to post_url(@post), status: :see_other
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def is_user
    if current_user.nil?
      respond_to do |format|
        format.html {redirect_to new_user_session_path, alert: "Log in to write comments!"}
        format.json { head :forbidden}
      end
    end
  end

  def is_user_comment_or_post
  end
end
