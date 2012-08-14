class BoardsController < ApplicationController
  before_filter :find_boards, except: [:create, :delete]
  
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
    @board = Board.find_by_directory(params[:directory])
    @post  = Post.new
    @reply = Post.new
    @posts = Post.where(directory: @board.directory)
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
  #protected
end
