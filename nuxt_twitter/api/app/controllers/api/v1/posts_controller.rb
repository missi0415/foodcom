class Api::V1::PostsController < ApplicationController
  include Pagenation #pagenation_controllerにて定義
  def index
    # posts = Post.all.page(params[:page]).per(5)
    posts = Post.where(post_id: 0).order(id: :desc).page(params[:page]).per(5)
    # posts = Post.where(post_id: 0).order(id: :desc)
    pagenation = resources_with_pagination(posts)
    # @images = posts.map { |post| post.image.url }
    # Rails側でurlまで取得しておかないと、Vue.jsで表示したときにconsoleに警告が出る。
    # @posts = posts.as_json
    # object = { posts: @posts, kaminari: pagenation }
    render json: posts
  end

  def show
    # post = Post.includes([:user]).find(params[:id])
    # comments = Post.where(:post_id params[:id])
    post = {}
    post[:post] = Post.find(params[:id])#postの中身
    post[:user] = User.find(post[:post].user_id)
    post[:comments] = Post.joins(:user).select("posts.*, user AS user").where(post_id: params[:id]).order(created_at: :desc)
    post[:like_posts] = LikePost.where(post_id: params[:id]).order(created_at: :desc)
    post[:like_count] = post[:like_posts].length
    unless Post.nil?
      render json: post
    else
      render json: { error_message: 'Not Found' }
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      p @post.post_id
      comment_count = Post.where(post_id: @post.post_id).length
      render json: comment_count
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

  def post_comments(id)
    return Post.where(post_id: id)
  end

  private

  def post_params
    params.require(:post).permit( :content, :user_id, :image, :post_id)
  end
end
