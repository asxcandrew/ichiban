class TripcodesController < ApplicationController
  load_and_authorize_resource

  def show
    @reply = Post.new
    @previews = 0
    @child_limit = 0

    @posts = Post.where(tripcode: params[:tripcode]).order("updated_at DESC").page(params[:page])
    @paged = params[:page]
    @prefix = "Posts for #{params[:tripcode]}"

    render 'boards/show'
  end
end
