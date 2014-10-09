class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    if params[:directory]
      @board = Board.find_by_directory!(params[:directory])
      check_if_user_can!(:edit, Board, @board)

      options = { layout: 'board_management' }
    end

    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to(root_url, 
                  notice: I18n.t('users.create.success', email: @user.email, role: @user.role))
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render "new"
    end
  end

  def show
  end

  def index
    options = {}
    @prefix = "Users"

    if params[:directory]
      @board = Board.find_by_directory!(params[:directory])
      check_if_user_can!(:manage, Board, @board)
      @users = @board.users
      options[:layout] = 'board_management'
    else
      current_user.check_if_operator!
      @users = current_user.users
    end

    respond_to do |format|
      format.html { render options }
      format.json { render json: @users }
    end
  end

  def destroy
    response = { success: false }
    @user = User.find_by_id(params[:id])

    if @user
      if check_if_user_can?(:destroy, User, @user)
        if @user.destroy
          response[:success] = true
          response[:message] = I18n.t('users.destroy.success', email: @user.email)
        else 
          response[:message] = @user.errors.full_messages.to_sentence
        end
      else
        response[:message] = I18n.t('users.errors.not_authorized', email: @user.email)
      end
    else
      response[:message] = I18n.t('users.errors.user_not_found', user_id: params[:id])
    end

    render json: response
  end
end
