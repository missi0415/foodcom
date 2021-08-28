class Api::V1::RelationshipsController < ApplicationController
# ——————フォロー機能を作成・保存・削除する————————————
  def create
    #paramsで:follow_idとuser_idを送る
    #送られてきたparams内の:follow_id
      p '送られてくる値--------', params
    current_user = User.find(params[:user_id])
    other_user = User.find(params[:follow_id]).id
    current_user.follow(other_user)
      p 'other_user--------------',other_user 
    # @result = { :follower_id => @current_user.id,
    #             :followed_id => @other_user.id }
    #   p 'result-----------------', @result
    # @relationship = Relationship.new(@result)
    #   @relationship.create!
    # @current_user.follow(params[:user_id])
    # @current_user.follow(@other_user)
    render json: {success_message: 'フォローしました' }
  end

  def destroy
    @current_user = User.find(params[:user_id])
    @current_user.unfollow(params[:id])
    # @other_user = User.find(params[:follow_id])
    # @current_user.unfollow(@other_user)
    # render json: @other_user
  end

  # def relationship_params
  #   params.require(:relationship).permit(:follower_id, :followed_id)
  # end

end
