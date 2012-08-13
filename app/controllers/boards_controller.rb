class BoardsController < ApplicationController
  before_filter :find_boards, except: [:create, :delete]
  def index
    @prefix = "Boards"
  end

  def new
    @prefix = "Create a new board"
    @board = Board.new
  end

  def create
    @board = Board.new(params[:board])

    if @board.save!
      flash[:notice] = 'Board created!'
      binding.pry
      # redirect url(:boards, :index)
    else
      # render 'boards/new'
      flash[:notice] = 'Something went wrong.'
    end
  end

  def show
    @board = Board.find_by_directory(params[:id])
    @post = Post.new
  end

  protected
    def find_boards
      @boards = Board.all
    end
  #protected
end
