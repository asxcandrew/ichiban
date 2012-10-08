class BoardsController < ApplicationController
  before_filter :find_boards, except: [:create, :delete]
  before_filter :set_board, except: [:index, :new, :create]
  before_filter :verify_permissions,
                only: [:new, :create, :delete, :update]
  
  def index
    @prefix = "Boards"
  end

  def new
    @prefix = "Create a new board"
    @board  = Board.new
  end

  def create
    @board = Board.new(params[:board])

    if @board.save
      flash[:notice] = 'Board created!'
      redirect_to boards_path
    else
      flash[:errors] = @board.errors.full_messages.to_sentence
      render new_board_path
    end
  end

  def show
    @post  = Post.new
    @reply = Post.new
    @image = @post.build_image
    @child_limit = 2
    if @board
      @posts = Post.where(directory: @board.directory, parent_id: nil).order("updated_at DESC").page(params[:page])
      @prefix = "/#{@board.directory}/"
    else
      render 'errors/error_404'
    end
  end

  def delete
  end

  def edit
  end

  def update
  end

  protected
    def find_boards
      @boards = Board.all
    end

    def set_board
      @board = Board.find_by_directory(params[:directory])
    end
  # protected_end
end
