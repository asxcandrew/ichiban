class PostsController < ApplicationController
  load_and_authorize_resource except: [:destroy]

  def show
    @reply = Post.new
    @post = Post.find_by_id(params[:id])
    @board = @post.board unless @post.nil?
    @child_limit = 10

    if @post && @board
      @prefix = I18n.t('posts.show.prefix', post_id: @post.id, board: @board.name)

      @prefix << ": #{@post.subject}" if @post.subject && !@post.subject.blank?

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
    @board = Board.find_by_id(params[:post][:board_id])
    # Simulate different IP addresses
    params[:post][:ip_address] = @board.save_IPs ? request.ip : Array.new(4){rand(256)}.join('.')
    
    @post = Post.new(params[:post])
    path_options = {}

    # Only a bot would see this field.
    if !params[:email].blank?
      logger.info "Spam Bot detected"
      redirect_to request.referrer
    else
      if @post.save
        cookies.signed[:passphrase] = { value: params[:post][:tripcode], expires: 1.week.from_now }
        cookies.signed[:name] = { value: @post.name, expires: 1.week.from_now }
        cookies.signed[:tripcode] = { value: @post.tripcode, expires: 1.week.from_now }

        # Used to delete posts.
        cookies.signed[@post.to_sha2] = {value: @post.ip_address, expires: 1.week.from_now }

        # flash[:notice] = I18n.t('posts.create.created', post_id: @post.id)

        if @post.parent
          redirect_to(request.referrer + "##{@post.id}")
        else
          redirect_to post_path(@post)
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
      response[:redirect] = board_path(@post.board) if params[:redirect] == true.to_s

      if check_if_user?(can?(:destroy, Post), @post) || cookies.signed[@post.to_sha2] == @post.ip_address

        if @post.destroy
          response.merge!(
            { success: true, 
              message: I18n.t('posts.destroy.deleted', post_id: @post.id) })

          flash[:notice] = I18n.t('posts.destroy.deleted', post_id: @post.id) if params[:redirect] == 'true'
          
          # Better clean up after ourselves.
          cookies.delete(@post.to_sha2)
        end

      else # Authorization failed.
        response[:message] = I18n.t('posts.destroy.not_authorized', post_id: params[:id])
      end

    else # Post doesn't exist.
      response[:message] = I18n.t('posts.destroy.not_found', post_id: params[:id])
    end

    render json: response
  end

  def update
  end
end
