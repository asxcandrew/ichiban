class BoardsController < ApplicationController
  before_filter :find_boards, except: [:destroy]
  before_filter :set_board, only: [:edit, :update, :show]
  load_and_authorize_resource
  
  def index
    @prefix = "Boards"
  end

  def new
    @prefix = "Create a new board"
    @board = Board.new
  end

  def create
    @board = Board.new(params[:board])

    if @board.save
      redirect_to boards_path, notice: "/#{@board.directory}/ created!"
    else
      flash[:error] = @board.errors.first[1]
      render action: 'new'
    end
  end

  def show
    @post  = Post.new
    @reply = Post.new
    @previews = 2
    @child_limit = 2
    if @board
      @posts = Post.threads_for(@board).order("updated_at DESC").page(params[:page])

      @paged = params[:page] 
      @prefix = "#{@board.name}"

      respond_to do |format|
        format.html
        format.json { render json: @posts }
      end
    else
      respond_to do |format|
        format.html { render 'errors/error_404' }
        format.json { render json: { error: 404 }.to_json, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @board = Board.find_by_id(params[:id])

    if @board
      if check_if_user?(can?(:manage, Board), @board)
        if @board.destroy
          redirect_to root_path, notice: I18n.t('boards.destroy.success', directory: @board.directory)
        else
          flash[:error] = @board.errors.first[1]
          render action: 'edit'
        end
      else
        raise CanCan::AccessDenied
      end
    else
      redirect_to root_path, error: I18n.t('boards.errors.board_not_found', board_id: params[:id])
    end
  end

  def edit
    raise CanCan::AccessDenied unless check_if_user?(can?(:update, Board), @board)
  end

  def update
    if check_if_user?(can?(:update, Board), @board)
      if @board.update_attributes(params[:board])
        redirect_to edit_board_path(@board), notice: I18n.t('boards.update.success')
      else
        flash[:error] = @board.errors.first[1]
        render action: 'edit'
      end
    else
      raise CanCan::AccessDenied
    end
  end

  protected
    def find_boards
      @boards = Board.order("name ASC").all
    end

    def set_board
      @board = Board.find_by_directory(params[:directory])
    end
  # protected_end
end
