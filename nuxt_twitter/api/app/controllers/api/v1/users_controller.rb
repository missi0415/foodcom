class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: users.as_json(only: %i[id name introduction avatar is_active admin])
  end

  def show
    user = User.find_by(id: params[:id])
    unless User.nil?
      render json: user
    else
      render json: { error_message: 'Not Found' }
    end
  end

  def create
    @user = User.new(user_params)
    @user.is_active = true
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    p params
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors,status: :unprocessable_entity
    end
  end

  def find_login_user
    user = User.find_by(uid: params[:uid])
    render json: user.as_json(only: %i[id name introduction avatar is_active admin])
  end

  #フォロ－機能
  def following
    user  = User.find(params[:id])
  end

  def followers
    user  = User.find(params[:id])
  end
  #-----------------

  def search_likes
    like_posts = []
    like_comments = []

    params[:like_post_ids].each do |post_id|
      like_posts.push(Post.find(post_id))
    end

    params[:like_comment_ids].each do |comment_id|
      like_comments.push(Comment.find(comment_id))
    end

    likes = like_posts.concat(like_comments)

    render json: likes, include: :user
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
      :avatar
    )
  end
end
