class PostsController < ApplicationController

  def show
    @reply = Post.new
    @post = Post.find_by_id(params[:id])
    @board = @post.board unless @post.nil?
    @child_limit = 10
    if @post && @board
      @prefix = I18n.t('posts.show.prefix', id: @post.id, board: @board.name)
      appendage = @post.ancestor ? @post.ancestor.subject : @post.subject
      @prefix << ": #{appendage}" if appendage

      respond_to do |format|
        format.html
        format.json { render json: @post }
      end
    else
      respond_to do |format|
        format.html { render 'errors/error_404' }
        format.json { render json: { error: 404 }.to_json, :status => :unprocessable_entity }
      end
    end
  end

  def create
    # Simulate different IP addresses
    params[:post][:ip_address] = Setting.save_IPs ? request.ip : Array.new(4){rand(256)}.join('.')
    @post = Post.new(params[:post])

    path_options = {}

    # Only a bot would see this field.
    if !params[:email].blank?
      redirect_to request.referrer
    else
      if @post.save
        flash[:notice] = I18n.t('posts.create.created', id: @post.id)

        if @post.parent
          redirect_to(request.referrer + "##{@post.id}")
        else
          redirect_to post_path(@post, anchor: @post.id)
        end

      else
        flash[:error] = @post.errors.first[1]
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
        response[:message] = I18n.t('posts.destroy.not_authorized', id: params[:id])
      end
    else
      response[:message] = I18n.t('posts.destroy.not_found', id: params[:id])
    end

    render json: response
  end

  def update
  end
end
