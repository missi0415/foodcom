class Api::V1::RelationshipsController < ApplicationController
  def create
    current_user = User.find(params[:user_id])
    other_user = User.find(params[:follow_id])
    current_user.follow(other_user)
    # Relationship Create (1.0ms)  INSERT INTO "relationships" ("follower_id", "followed_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["follower_id", 1], ["followed_id", 2]
    if Relationship.create(follower_id: current_user.id, followed_id: other_user.id)
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
