class Api::V1::UsersController < ApplicationController
  include Pagination
  def index
    users = User.all
    render json: users.as_json(only: %i[id name introduction avatar is_active admin])
  end

  def show
    user = {}
    user[:user] = User.find(params[:id])
    user[:posts] = Post.select(:id).where(post_id: 0).where(user_id: params[:id]).order(created_at: :desc)
    like_posts = []
      user_likes = user[:user].like_posts.order(created_at: :desc).pluck(:post_id) 
      user_likes.each do |f|
        post = Post.select(:id).find(f)
        like_posts.push(post)
      end
    user[:like_posts] = like_posts
    post_and_comments = []
      user_comments = Post.select(:id,:post_id).where.not(post_id: 0).where(user_id: params[:id]).order(created_at: :desc).pluck(:post_id, :id)
      user_comments.each_with_index do |f, i|
        post_and_comment = {}
        post_and_comment[:post] = Post.select(:id).find(f[0])
        post_and_comment[:comment] = Post.select(:id).find(f[1])
        post_and_comments.push(post_and_comment)
      end
    user[:post_and_comments] = post_and_comments
    user[:follower_user] = user[:user].follower_user
    user[:following_user] = user[:user].following_user
    user[:following_users] = user[:user].following_user.pluck(:id)
    user[:have_images] = Post.select(:id).where.not(image: nil).where(user_id: params[:id])
    unless User.nil?
      render json: user
    else
      render json: { error_message: 'Not Found' }
    end
  end

  def create
    user = User.new(user_params)
    user.is_active = true
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors,status: :unprocessable_entity
    end
  end

  def find_login_user
    user = User.find_by(uid: params[:uid])
    render json: user.as_json(only: %i[id name uid introduction avatar is_active admin])
  end
  
  def following_users
    data = {}
    user = User.find(params[:id])
    data[:following_users] = user.following_user.pluck(:id)
    render json: data
  end

  def followers
    user  = User.find(params[:id])
  end


  def search_likes
    like_posts = []
    params[:like_post_ids].each do |post_id|
      like_posts.push(Post.find(post_id))
    end
    render json: like_posts, include: :user
  end



  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :uid,
      :introduction,
      :is_active,
      :admin,
      :avatar,
      :header
    )
  end
end
