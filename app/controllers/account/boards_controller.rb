class Account::BoardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_boards, except: [:destroy, :search]
  before_filter :set_board, except: [:index, :new, :create, :search]
  before_filter :authenticate_user!, except: [:index, :show, :search]

  def index
    if (current_user.has_role? :operator )|| (current_user.has_role? :administrator)
      @boards = Board.all
    else
      @boards = Board.with_role(:owner, current_user) + Board.with_role(:moderator, current_user)
    end
  end

  def new
    @prefix = "Create a new board"
    @board = Board.new
  end

  def create
    @board = Board.create!(ad_params)
    redirect_to edit_account_board_path(@board), notice: "/#{@board.directory}/ created!"
  end

  def destroy
    authorize! :destroy, @board
    @board.destroy
    redirect_to root_path, notice: I18n.t('boards.destroy.success', directory: @board.directory)
  end

  def edit
    if can?(:manage, @board)
      render layout: 'board_management'
    else
      redirect_to account_board_reports_path(@board)
    end
  end

  def update
    authorize! :update, @board
    @edited_board = @board.clone
    @edited_board.update_attributes!(params[:board])

    redirect_to edit_board_path(@edited_board), notice: I18n.t('boards.update.success')
  end
  private
    def ad_params
      params.require(:board).permit(:name, :directory, :description)
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
