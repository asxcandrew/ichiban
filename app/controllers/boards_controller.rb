class BoardsController < ApplicationController
  # before_filter :find_boards, except: [:destroy, :search]

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
    Rails.logger.debug current_board
    @prefix = current_board.name
    @posts = Post.threads_for(current_board).order('locked DESC').order('updated_at DESC').page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @posts, except: [:ip_address], :include => :image }
    end
  end

  protected
    def find_boards
      @boards = Board.order("name ASC").all
    end
  # protected_end
end
