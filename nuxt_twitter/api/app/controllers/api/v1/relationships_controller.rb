class Api::V1::RelationshipsController < ApplicationController
# ——————フォロー機能を作成・保存・削除する————————————
def create
  #paramsで:follow_idとuser_idを送る
  #送られてきたparams内の:follow_id
  other_user = User.find(params[:follow_id])
  current_user.follow(params[:user_id])
  current_user.follow(@other_user)
  current_user.notice_follow(@current_user.id, @other_user.id)
    render json: @other_user

end

def destroy
  @other_user = User.find(params[:follow_id])
  @current_user = User.find(params[:user_id])
  @current_user.unfollow(@other_user)
  render json: @other_user
end

# #————————フォロー・フォロワー一覧を表示する-————————————
# def followings
#   user = User.find(params[:user_id])
#   @users = user.followings
# end

# def followers
#   user = User.find(params[:user_id])
#   @users = user.followers
# end
  ### フォローする ###
  def follow(other_user)
    following << other_user
  end

  ### フォローを解除 ###
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  ### フォローしているか ###
  def following?(other_user)
    following.include?(other_user)
  end

  ### フォローされているか ###
  def followers?(other_user)
    followers.include?(other_user)
  end

  def notice_follow(visitor_id, visited_id)
    visited = User.find(visited_id)
    visitor = User.find(visitor_id)
    follow_notice = visitor.active_notices.new(
      visitor_id: visitor.id,
      visited_id: visited.id,
      action: 'follow'
    )
    follow_notice.save
  end

end
