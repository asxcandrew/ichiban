class HomeController < ApplicationController
  def index
    @posts = Post.all_threads.page(params[:page])
    respond_to do |format|
      format.html {render 'boards/show'}
      format.json { render json: @boards }
    end
  end
end
