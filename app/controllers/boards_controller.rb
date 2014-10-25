class BoardsController < ApplicationController
  before_filter :find_boards, except: [:destroy, :search]
  before_filter :set_board, except: [:index, :new, :create, :search]
  before_filter :authenticate_user!, except: [:index, :show, :search]
  
  def search
    @boards = params[:keyword] ? Board.where('name ILIKE ?', "%#{params[:keyword]}%").limit(5) : []

    render json: @boards
  end

  def index
    @posts = Post.all_threads.order("updated_at DESC").page(params[:page])
    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: @posts, except: [:ip_address], :include => :image }
    end
  end

  def new
    @prefix = "Create a new board"
    @board = Board.new
  end

  def create
    @board = Board.create!(params[:board])
    redirect_to edit_board_path(@board), notice: "/#{@board.directory}/ created!"
  end

  def show
    @prefix = "#{@board.name}"
    @posts = Post.threads_for(@board).order("updated_at DESC").page(params[:page])

    @paged = params[:page] 

    respond_to do |format|
      format.html
      format.json { render json: @posts, except: [:ip_address], :include => :image }
    end
  end

  def destroy
    check_if_user_can!(:destroy, Board, @board)
    @board.destroy
    redirect_to root_path, notice: I18n.t('boards.destroy.success', directory: @board.directory)
  end

  def edit
    authorize! :edit, @board
    # check_if_user_can!(:edit, Board, @board)
    render layout: 'board_management'
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
