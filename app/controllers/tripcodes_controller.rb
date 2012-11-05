class TripcodesController < ApplicationController
  load_and_authorize_resource

  def show
    @reply = Post.new
    @previews = 0
    @child_limit = 0

    context = params[:secure] ? :secure_tripcode : :tripcode
    @posts = Post.where(context => params[:tripcode]).order("updated_at DESC").page(params[:page])
    @paged = params[:page]
    @prefix = "Posts for #{params[:tripcode]}"

    render 'boards/show'
  end
end
