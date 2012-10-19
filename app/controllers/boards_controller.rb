class BoardsController < ApplicationController
  before_filter :find_boards, except: [:delete]
  before_filter :set_board, except: [:index, :new, :create]
  before_filter :verify_permissions,
                except: [:index, :show]
  
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
    @child_limit = 2
    @preview_limit = 1

    if @board
      @posts = Post.where(directory: @board.directory, 
                          parent_id: nil).order("updated_at DESC").page(params[:page])
      @prefix = "#{@board.name}"
    else
      render 'errors/error_404'
    end
  end

  def destroy
    if @board.destroy
      redirect_to root_path, notice: "/#{@board.directory}/ permanently deleted."
    else
      flash[:errors] = @board.errors.first[1]
      render action: 'edit'
    end
  end

  def edit
    @stats = { posts: @board.posts.size }
  end

  def update
    if @board.update_attributes(params[:board])
      redirect_to edit_board_path(@board), notice: "Board settings have been successfully updated."
    else
      flash[:errors] = @board.errors.first[1]
      render action: 'edit'
    end
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
