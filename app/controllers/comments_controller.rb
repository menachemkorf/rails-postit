class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:create]


  def create
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.user = current_user

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])

    vote = Vote.new(vote: params[:vote], user: current_user, voteable: comment)
    if vote.save
      flash[:notice] = 'Your vote was counted.'
    else
      flash[:error] = 'You already voted for this comment.'
    end

    redirect_to(:back)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end