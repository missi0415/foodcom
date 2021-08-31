class Api::V1::PostsController < ApplicationController
  def index
    posts = Post.all.includes(:user).order(id: :desc)
    @images = posts.map { |post| post.image.url }
    # Rails側でurlまで取得しておかないと、Vue.jsで表示したときにconsoleに警告が出る。
    render json: posts, include: [
      :user,
      {like_posts: [:post] },
      { comments: [:user] },
      { comments: [:like_comment] }
    ]
  end

  def show
    post = Post.includes([:user]).find(params[:id])
    unless Post.nil?
      render json: post, include: [
        :user,
        :like_posts,
        { comments: [:user] },
        { comments: [:like_comment] }
      ]
    else
      render json: { error_message: 'Not Found' }
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post, include: [:user, { comments: [:user] }]
    else
      render json: post.errors.messages
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      render json: post
    else
      render json: post.errors
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :image)
  end
end
