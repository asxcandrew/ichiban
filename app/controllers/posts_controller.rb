class PostsController < ApplicationController
  load_and_authorize_resource except: [:destroy]

  def new
    @board = Board.find_by_id(params[:board_id])
    @post = Post.new
  end

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
    end
  end

  def create
    params[:post][:ip_address] = request.ip
    
    # Only a bot would see this field.
    if !params[:email].blank?
      logger.info "Spam Bot detected: #{request.ip}"
      redirect_to request.referrer
    else
      @post = Post.create!(params[:post])
      cookies.signed[:passphrase] = { value: params[:post][:tripcode], expires: 1.week.from_now }
      cookies.signed[:name] = { value: @post.name, expires: 1.week.from_now }
      cookies.signed[:tripcode] = { value: @post.tripcode, expires: 1.week.from_now }

      # Used to delete posts.
      cookies.signed[@post.to_sha2] = { value: @post.ip_address, expires: 1.week.from_now }

      redirect_to(@post.is_ancestor? ? post_path(@post) : post_path(@post.ancestor, anchor: @post.id))
    end
  end

  def destroy
    @post = Post.find_by_id!(params[:id])
    response = { flash: { :type => :notice } }
    # No sense in keeping them on a page without a parent.
    response[:redirect] = board_path(@post.board) if params[:redirect] == true.to_s

    cookies.signed[@post.to_sha2] == @post.ip_address || check_if_user_can!(:destroy, Post, @post)
    @post.destroy
    flash[:notice] = I18n.t('posts.destroy.deleted', post_id: @post.id)
    response[:flash][:message] = I18n.t('posts.destroy.deleted', post_id: @post.id)
    # Better clean up after ourselves.
    cookies.delete(@post.to_sha2)

    render json: response
  end

  def update
  end
end
