class PostsController < ApplicationController

  def show
    @reply = Post.new
    @board = Board.find_by_directory(params[:directory])
    @post = Post.find_by_id(params[:id])
    
    render 'errors/error_404' unless @board && @post
  end

  def create
    @board = Board.find_by_directory(params[:directory])
    @post  = Post.new(params[:post])
    path_options = {}

    @post.directory  = params[:directory]
    @post.ip_address = request.ip
    

    # TODO: Handle situation where parent doesn't exist.
    if @post.parent_id # Post is a reply.
      @parent = Post.find(@post.parent_id)
      @post.directory = @parent.directory
    end

    if @post.save
      flash[:notice] = 'Post created!'

      if @post.parent
        redirect_to(request.referrer + "##{@post.id}")
      else
        redirect_to board_post_path(@board, @post, anchor: @post.id)
      end

    else
      flash[:errors] = @post.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end

  def destroy
    # TODO: Redirect to board if post is parent.
    @post = Post.find_by_id(params[:id])
    response = {}

    if @post
      # No sense in keeping them on a page without a parent.
      if @post.parent
        response[:redirect] = false
      else
        @board = Board.find_by_directory(@post.directory)
        response[:redirect] = board_path(@board)
      end

      if @post.destroy(params[:tripcode])
        response.merge!(
          { success: true, 
            message: "Deleted post ##{@post.id}." })
      else
        response.merge!(
          { success: false, 
            message: "You are not the creator of post ##{@post.id}." })
      end

    else # Post wasn't found
      response.merge!(
        { success: false, 
          message: "Post ##{params[:id]} does not exist." })
    end

    render json: response
  end

  def edit
  end

  def update
  end
end
