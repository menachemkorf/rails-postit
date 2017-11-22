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
    @comment = Comment.find(params[:id])

    @vote = Vote.create(vote: params[:vote], user: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = 'You already voted for this comment.'
        end

        redirect_to :back
      end

      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:post_id])
  end
end