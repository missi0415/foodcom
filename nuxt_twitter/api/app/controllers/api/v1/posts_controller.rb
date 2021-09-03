class Api::V1::PostsController < ApplicationController
  def index
    posts = Post.where(post_id: 0).includes(:user).order(id: :desc)
    # posts = Post.all.includes(:user).order(id: :desc)
    @images = posts.map { |post| post.image.url }
    # Rails側でurlまで取得しておかないと、Vue.jsで表示したときにconsoleに警告が出る。
    render json: posts, include: [
      :user,
      {like_posts: [:post] }
    ]
  end

  def show
    post = Post.includes([:user]).find(params[:id])
    p 'post', post
    unless Post.nil?
      render json: post, include: [
        :user,
        :like_posts
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
      render json: post
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
    params.require(:post).permit(:title, :content, :user_id, :image, :post_id)
  end
end
