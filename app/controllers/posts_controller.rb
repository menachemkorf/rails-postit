class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, except: [:index, :show]

  def index
    @posts = Post.all.sort_by(&:total_votes).reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = 'Your post was created.'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'The post was updated.'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], user: current_user, voteable: @post)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = 'You already voted for this post.'
        end

        redirect_to :back
      end

      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
end
