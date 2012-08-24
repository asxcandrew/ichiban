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

    @post.directory  = params[:directory]
    @post.ip_address = request.ip
    
    path_options = {}

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

    # If the post was found
    if @post
      if @post.destroy(params[:tripcode])
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

    # No sense in keeping them on a page without a parent.
    response[:redirect] = @post.parent ? false : true 
    render json: response
  end

  def edit
  end

  def update
  end
end
