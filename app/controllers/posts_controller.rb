class PostsController < ApplicationController
  include SimpleCaptcha::ControllerHelpers
  # load_and_authorize_resource except: [:destroy]

  def new
    @prefix = I18n.t('posts.new.prefix')
    @board = Board.find_by_directory(params[:board_directory])
    if @board
      @post = Post.new
      @post.board = @board
    else
      redirect_to request.referrer
    end
  end

  def show
    @post = Post.joins(:board).where(related_id: params[:related_id], boards:{directory: params[:board_directory]}).first
    @reply = Post.new
    @board = @post.board
    @child_limit = 10
    @counter = 0
    if @post && @board
      @prefix =  @post.subject && !@post.subject.blank? ? "#{@post.subject} : " : ""
      @prefix << I18n.t('posts.show.prefix', post_id: @post.id, board: @board.name)
      respond_to do |format|
        format.html
        format.json do
          omitted = []
          # omitted << :ip_address unless check_if_user_can?(:create, Suspension, @post)
          render json: @post, 
                  except: omitted, 
                  :include => :image, 
                  html_newlines: params[:html_newlines]
        end 
      end
    end
  end

  def create
    if simple_captcha_valid?
      params.permit!
      params[:post][:ip_address] = request.ip
      
      # Only a bot would see this field.
      if !params[:email].blank?
        logger.info "Spam Bot detected: #{request.ip}"
        redirect_to request.referrer
      else
        @post = Post.create(params[:post])
        cookies.signed[:passphrase] = { value: params[:post][:tripcode], expires: 1.week.from_now }
        cookies.signed[:name] = { value: @post.name, expires: 1.week.from_now }
        cookies.signed[:tripcode] = { value: @post.tripcode, expires: 1.week.from_now }

        # Used to delete posts.
        cookies.signed[@post.to_sha2] = { value: @post.ip_address, expires: 1.week.from_now }

        redirect_to(@post.is_ancestor? ? view_context.post_path(@post) : view_context.post_path(@post.ancestor, anchor: @post.related_id))
      end
    else
      flash[:error] = t('simple_captcha.message.default')
      redirect_to :back
    end
 
  end

  def destroy
    @post = Post.joins(:board).where(related_id: params[:related_id], boards:{directory: params[:board_directory]}).first
    authorize! :manage, @post.reports.last
    # response = { flash: { :type => :notice } }
    # No sense in keeping them on a page without a parent.
    response[:redirect] = board_path(@post.board) if params[:redirect] == true.to_s

    cookies.signed[@post.to_sha2] == @post.ip_address
    @post.destroy
    # flash[:notice] = I18n.t('posts.destroy.deleted', post_id: @post.id)
    # response[:flash][:message] = I18n.t('posts.destroy.deleted', post_id: @post.id)
    # Better clean up after ourselves.
    cookies.delete(@post.to_sha2)

    render json: response
  end

  def update
  end
end
