class Api::V1::RelationshipsController < ApplicationController
  def create
    current_user = User.find(params[:user_id])
    other_user = User.find(params[:follow_id])
    unless current_user.following_user.include?(other_user)
      current_user.following_user << other_user
      other_user.create_notification_follow!(current_user)
      render json: other_user
    else
      render json: { errors_message: '失敗しました' }
    end
  end

  def destroy
    other_user = User.find(params[:follow_id])
    current_user = User.find(params[:user_id])
    current_user.unfollow(other_user)
    render json: other_user
  end
end
