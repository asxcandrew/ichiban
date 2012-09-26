class PostsController < ApplicationController

  def show
    @reply = Post.new
    @board = Board.find_by_directory(params[:directory])
    @post = Post.find_by_id(params[:id])
    @total_replies = Post.where(parent_id: params[:id]).size
    
    render 'errors/error_404' unless @board && @post
  end

  def create
    @board = Board.find_by_directory(params[:directory])
    @post  = Post.new(params[:post])
    path_options = {}

    @post.directory  = params[:directory]
  
    # Simulate different IP addresses
    @post.ip_address = Rails.env.production? ? request.ip : Array.new(4){rand(256)}.join('.')

    # TODO: Handle situation where parent doesn't exist.
    if @post.parent_id # Post is a reply.
      @parent = Post.find(@post.parent_id)
      @post.directory = @parent.directory
    end

    # Only a bot would see this field.
    if !params[:email].blank?
      redirect_to request.referrer
    else
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
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    response = { success: false }
    if @post
      if @post.destroy_post_and_upload
        response = { success: true,
                     message: "Deleted post ##{@post.id}." }

        if params[:getReportTotal]
          report = Report.new
          response[:report_total] = report.total
        end
      else
        response[:message] = @post.errors.full_messages.to_sentence
      end
    else
      response[:message] = "Post ##{params[:id]} not found."
    end

    render json: response
  end

  def destroy_with_tripcode
    @post = Post.find_by_id(params[:id])
    response = { success: false }

    if @post
      # No sense in keeping them on a page without a parent.
      if @post.parent
        response[:redirect] = false
      else
        @board = Board.find_by_directory(@post.directory)
        response[:redirect] = board_path(@board)
      end

      if @post.destroy_with_tripcode(params[:tripcode])
        response.merge!(
          { success: true, 
            message: "Deleted post ##{@post.id}." })
      else
        response[:message] = "You are not the creator of post ##{@post.id}."
      end

    else # Post wasn't found
      response[:message] = "Post ##{params[:id]} not found."
    end

    render json: response
  end

  def update
  end
end
