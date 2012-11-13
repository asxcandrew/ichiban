class UsersController < ApplicationController
  load_and_authorize_resource
  
  def new
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

  def index
    if params[:directory]
      @board = Board.find_by_directory(params[:directory])
      if check_if_user?(can?(:manage, Board), @board)
        @users = @board.users 
      else
        raise CanCan::AccessDenied
      end

    elsif @current_user.operator?
      @users = @current_user.users
    else
      raise CanCan::AccessDenied
    end
  end

  def destroy
    response = { success: false }
    @user = User.find_by_id(params[:id])

    if @user
      if check_if_user?(can?(:destroy, User), @user)
        if @destroy
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
