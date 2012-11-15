class PostsController < ApplicationController
  load_and_authorize_resource except: [:destroy]

  def show
    @post = Post.find_by_id(params[:id])
    @reply = Post.new
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
    # @post = Post.new(params[:post])
    # Simulate different IP addresses
    @post.ip_address = @post.board.save_IPs ? request.ip : Array.new(4){rand(256)}.join('.')
    
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
        cookies.signed[@post.to_sha2] = { value: @post.ip_address, expires: 1.week.from_now }

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
    @post = Post.find_by_id!(params[:id])
    response = {}
    # No sense in keeping them on a page without a parent.
    response[:redirect] = board_path(@post.board) if params[:redirect] == true.to_s

    if cookies.signed[@post.to_sha2] == @post.ip_address || check_if_user_can!(:destroy, Post, @post)
      if @post.destroy
        response[:flash] = { :type => :notice, message: I18n.t('posts.destroy.deleted', post_id: @post.id) }

        # Better clean up after ourselves.
        cookies.delete(@post.to_sha2)
      end
    end

    render json: response
  end

  def update
  end
end
