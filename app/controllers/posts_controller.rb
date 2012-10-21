class PostsController < ApplicationController

  def show
    @reply = Post.new
    @post = Post.find_by_id(params[:id])
    @board = @post.board unless @post.nil?
    @child_limit = 10
    if @board && @post
      @prefix = "Viewing post ##{@post.id} on #{@board.name}"
    else
      render 'errors/error_404'
    end
  end

  def create
    @post  = Post.new(params[:post])
    path_options = {}

    # Simulate different IP addresses
    @post.ip_address = Setting.save_IPs ? request.ip : Array.new(4){rand(256)}.join('.')
    # Only a bot would see this field.
    if !params[:email].blank?
      redirect_to request.referrer
    else
      if @post.save
        flash[:notice] = "Post ##{@post.id} created!"

        if @post.parent
          redirect_to(request.referrer + "##{@post.id}")
        else
          redirect_to post_path(@post, anchor: @post.id)
        end

      else
        flash[:errors] = @post.errors.first[1]
        redirect_to request.referrer
      end
    end
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    response = { success: false }

    if @post
      # No sense in keeping them on a page without a parent.
      response[:redirect] = board_path(@post.board) if params[:redirect] == 'true'
      
      if can?(:destroy, Post) || @post.verify_tripcode(params[:tripcode])
        if @post.destroy
          response.merge!(
            { success: true, 
              message: "Deleted post ##{@post.id}." })

          response[:report_total] = Report.all.size if params[:getReportTotal]
        end
      else
        response[:message] = "You are not authorized to delete post ##{params[:id]}."
      end
    else
      response[:message] = "Post ##{params[:id]} not found."
    end

    render json: response
  end

  def update
  end
end
