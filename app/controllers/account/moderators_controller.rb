class Account::ModeratorsController < ApplicationController
  before_filter :set_template
  before_filter :authenticate_user!#, only: [:create , :destroy]
  
  def new
    @boards = Board.with_role(:owner, current_user)
    # authorize! :manage, @board
  end

  def create
    @board = Board.find_by_directory!(params[:board_directory])
    authorize! :manage, @board
    @user = User.where(email: params[:moderator][:email]).first
    if @user.present?
      @user.add_role :moderator, @board
      flash[:notice] = I18n.t('users.create.success', email: @user.email, role: 'moderator')
      render "index"
    else
      flash[:error] = 'Фейкомыло не найдено!'
      render "new"
    end
  end

  def edit
  end

  def show
  end

  def index
    options = {}
    @prefix = t('moderators.index.prefix')
    if current_user.has_role? :operator
      @administrators = User.with_role :administrator
    else
      @boards = Board.with_role(:owner, current_user)
    end
      # @board = Board.find_by_directory!(params[:board_directory])
      # # authorize! :manage, @board
      # @users = User.with_role :moderator, @board

    respond_to do |format|
      format.html { render options }
      format.json { render json: @users }
    end
  end

  def destroy
    @board = Board.find_by_directory!(params[:board_directory])
    authorize! :manage, @board
    @user = User.find_by_id(params[:id])
    @user.remove_role :moderator, @board if @user
    redirect_to account_board_moderators_path(params[:board_directory])
  end

  private
    def set_template
      self.class.layout('layouts/board_management')
    end

end
