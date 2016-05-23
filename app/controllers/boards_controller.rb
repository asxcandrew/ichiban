class BoardsController < ApplicationController
  # before_filter :find_boards, except: [:destroy, :search]
  before_filter :set_current_board, except: [:index, :search]

  def search
    @boards = params[:keyword] ? Board.where('name LIKE ?', "%#{params[:keyword]}%").limit(5) : []
    render json: @boards
  end

  def index
    @boards = Board.order("updated_at DESC").page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @boards }
    end
  end

  def show
    @prefix = "#{@board.name}"
    @posts = Post.threads_for(@board).order('locked DESC').order('updated_at DESC').page(params[:page])

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

    def set_current_board
      @current_board = Board.find_by_directory!(params[:directory])
    end
  # protected_end
end
