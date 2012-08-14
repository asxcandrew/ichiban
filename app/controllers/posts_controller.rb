class PostsController < ApplicationController

  def show
    @board = Board.find_by_directory(params[:directory])
    @post  = Post.find(params[:id])
    @reply = Post.new
  end

  def create
    @board = Board.find_by_directory params[:directory]
    @post  = Post.new(params[:post])
    path_options = {}

    if @post.parent_id # Post is a reply.
      @parent = Post.find(@post.parent_id)
      @post.directory = @parent.directory
    end

    if @post.save!
      flash[:notice] = 'Post created!'
      redirect_to board_post_path(@board, @post, anchor: @post.id)
    else
      flash[:notice] = 'Something went wrong.'
      render board_path(@board)
    end
  end

  def delete
  end

  def edit
  end

  def update
  end
end
