class Api::V1::CommentsController < ApplicationController

  def show
    comment = Comment.find(params[:id])
    render json: comment
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment
    else
      render json: comment.errors.messages
    end
  end

  def update
    comment = Comment.find(params[:id])
    comment.content = params[:content]
    if comment.update(comment_params)
      render json: comment
    # if comment.update(comment_params) && comment.comment_id == 0
    #   # comment_idは0→新規投稿
    #   # post = Post.find(params[:post_id])
    #   # render json: post, include: [:user, { comments: [:user] }]
    #   render json: { success_message: '更新しました', }
    # elsif comment.update(comment_params) && comment.comment_id != 0
    #   # comment_id0以外なら
    #   # nuxt側でcomment_idにcomment.idをいれる
    #   render json: { success_message: '更新しました', }
    else
      comment.errors.messages
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comments = Comment.where(comment_id: params[:id])
    if comment.destroy
      comments.destroy_all
      # comment_id はrailsをかいしてつけた外部キーではないためdependent.destroyと同じ動きをここで指定
      render json: { success_message: '削除しました' }
    else
      render json: { error_message: '削除に失敗しました' }

    end
  end


  def search_comments
    comments = Comment.where(comment_id: params[:id]).includes(:post, :user).order(created_at: :desc)
    render json: comments
  end
  
  # def comment_count(com_id) 
  #   count =Comment.where(comment_id: com_id).count
  #   render json: count
  # end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :comment_id, :content)
  end
end
