class PostsController < ApplicationController

  def show
    @reply = Post.new
    @board = Board.find_by_directory(params[:directory])
    @post = Post.find_by_id(params[:id])
    
    render 'errors/error_404' unless @board && @post
  end

  def create
    @board = Board.find_by_directory params[:directory]
    @post  = Post.new(params[:post])
    @post.ip_address = request.ip
    path_options = {}

    # TODO: Handle situation where parent doesn't exist.
    if @post.parent_id # Post is a reply.
      @parent = Post.find(@post.parent_id)
      @post.directory = @parent.directory
      
      # Redirect to the parent.
      path = @parent
    else
      # Redirect to the post.
      path = @post
    end

    if @post.save!
      flash[:notice] = 'Post created!'
      redirect_to board_post_path(@board, path, anchor: @post.id)
    else
      flash[:notice] = 'Something went wrong.'
      render board_path(@board)
    end
  end

  def destroy
    @post = Post.find_by_id(params[:id])

    if @post
      # If the post was found, attempt to destroy it.
      if @post.destroy
        response = { success: true, 
                     message: "Deleted post ##{@post.id}." }
      else
        response = { success: false, 
                     message: "You are not the creator of post ##{@post.id}." }
      end
    else
      response = { success: false, 
                   message: "Post ##{params[:id]} does not exist." }
    end

    render json: response
  end

  def edit
  end

  def update
  end
end
