class PostsController < ApplicationController

  def show
    @post = Post.find(params[:id])
    # @board = Board.find_by_directory
  end

  def create
    @post = Post.new(params[:post])
    path_options = {}

    if @post.parent_id # Post is a reply.
      @parent = Post.find(@post.parent_id)
      @post.directory = @parent.directory
    end

    if @post.save!
      path_options[:id] = @post.parent_id || @post.id
      path_options[:directory] = @post.directory

      flash[:notice] = 'Post created!'

      anchor = "##{@post.id}"
      redirect url(:boards, :thread, path_options) + anchor
    else
      render url(:boards, :index, directory: params[:post][:directory])
      flash[:notice] = 'Something went wrong.'
    end
  end
end
