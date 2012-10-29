class TripcodesController < ApplicationController
  def show
    @post  = Post.new
    @reply = Post.new
    @previews = 2
    @child_limit = 2

    @posts = Post.where(tripcode: params[:tripcode]).order("updated_at DESC").page(params[:page])
    @paged = params[:page] 
    @prefix = "Posts for #{params[:tripcode]}"

    render 'boards/show'
  end
end
