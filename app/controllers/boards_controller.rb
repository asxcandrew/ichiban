class BoardsController < ApplicationController
  before_filter :find_boards, except: [:delete]
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
    if @board.destroy
      redirect_to root_path, notice: "/#{@board.directory}/ permanently deleted."
    else
      flash[:error] = @board.errors.first[1]
      render action: 'edit'
    end
  end

  def edit
    if @current_user.boards.include?(@board)
      @stats = { posts: @board.posts.size }
    else
      raise CanCan::AccessDenied
    end
  end

  def update
    if @board.update_attributes(params[:board])
      redirect_to edit_board_path(@board), notice: "Board settings have been successfully updated."
    else
      flash[:error] = @board.errors.first[1]
      render action: 'edit'
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
