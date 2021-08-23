class PostsController < ApplicationController
  def index
    posts = Post.all.includes(:user).order(id: :desc)
    render json: posts,each_serializer: PostSerializer
end
