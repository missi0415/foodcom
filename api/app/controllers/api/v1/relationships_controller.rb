class Api::V1::RelationshipsController < ApplicationController
  def create
    current_user = User.find(params[:user_id])
    other_user = User.find(params[:follow_id])
    current_user.follow(other_user)
    render json: other_user
  end

  def destroy
    other_user = User.find(params[:follow_id])
    current_user = User.find(params[:user_id])
    current_user.unfollow(other_user)
    render json: other_user
  end
end
