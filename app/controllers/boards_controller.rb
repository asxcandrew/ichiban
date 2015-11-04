class BoardsController < ApplicationController
  # before_filter :find_boards, except: [:destroy, :search]
  before_filter :set_board, except: [:index, :search]
  
  def search
    @boards = params[:keyword] ? Board.where('name LIKE ?', "%#{params[:keyword]}%").limit(5) : []
    render json: @boards
  end

  def index
    @posts = Post.all_threads.order("updated_at DESC").page(params[:page])
    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: @posts, except: [:ip_address], :include => :image }
    end
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

  protected
    def find_boards
      @boards = Board.order("name ASC").all
    end

    def set_board
      @board = Board.find_by_directory!(params[:directory])
    end
  # protected_end
end
