class BoardsController < ApplicationController
  before_filter :find_boards, except: [:destroy]
  before_filter :set_board, except: [:index, :new, :create]
  load_and_authorize_resource
  
  def index
    @prefix = "Boards"
  end

  def new
    @prefix = "Create a new board"
    @board = Board.new
  end

  def create
    @board = Board.create!(params[:board])
    redirect_to boards_path, notice: "/#{@board.directory}/ created!"
  end

  def show
    @post  = Post.new
    @reply = Post.new
    @previews = 2
    @child_limit = 2
    @prefix = "#{@board.name}"
    @posts = Post.threads_for(@board).order("updated_at DESC").page(params[:page])

    @paged = params[:page] 

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def destroy
    check_if_user_can!(:destroy, Board, @board)
    @board.destroy
    redirect_to root_path, notice: I18n.t('boards.destroy.success', directory: @board.directory)
  end

  def edit
    check_if_user_can!(:edit, Board, @board)
  end

  # TODO: Fix issue where invalid records alter the edit view.
  def update
    check_if_user_can!(:update, Board, @board)
    
    @edited_board = @board.clone
    @edited_board.update_attributes!(params[:board])

    redirect_to edit_board_path(@edited_board), notice: I18n.t('boards.update.success')
  end

  protected
    def find_boards
      @boards = Board.order("name ASC").all
    end

    def set_board
      @board = Board.find_by_directory!(params[:directory])
    end
  # protected_end
end
