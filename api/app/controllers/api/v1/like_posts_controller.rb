class Api::V1::LikePostsController < ApplicationController
  def show
    likes = LikePost.where(post_id: params[:id])
    render json: likes
  end
  
  def create
    like = LikePost.new(like_post_params)
    if like.save
      current_user = User.find(params[:user_id])
      post = Post.find(params[:post_id])
      post.create_notification_like!(current_user)
      user_likes = LikePost.where(user_id: like.user_id)
      render json: user_likes
    else
      render json: { error_message: '失敗しました' }
    end
  end

  def destroy
    like = LikePost.find_by(user_id: params[:user_id], post_id: params[:post_id])
    p 'likeの値' ,like
    if like.destroy
      render json: like
    else
      render json: { errors_message: '失敗しました' }
    end
  end

  private

  def like_post_params
    params.require(:like_post).permit(:user_id, :post_id)
  end
end
