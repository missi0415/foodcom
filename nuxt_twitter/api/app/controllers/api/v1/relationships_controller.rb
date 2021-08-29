class Api::V1::RelationshipsController < ApplicationController
# ——————フォロー機能を作成・保存・削除する————————————
  def create
    #paramsで:follow_idとuser_idを送る
    #送られてきたparams内の:follow_id
      p '送られてくる値--------', params
    current_user = User.find(params[:user_id])
      p current_user
    other_user = User.find(params[:follow_id])
    p 'other_user--------------',other_user 
    current_user.follow(other_user)
    render json: other_user
  end

  def destroy
    p '送られてくる値--------', params
    other_user = User.find(params[:follow_id])
    p 'destroyother_user ---------',other_user
    current_user = User.find(params[:user_id])
    current_user.unfollow(other_user)
    render json: other_user

  end

  # def relationship_params
  #   params.require(:relationship).permit(:follower_id, :followed_id)
  # end

end
