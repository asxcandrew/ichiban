class SessionsController < ApplicationController
  def new
    redirect_to root_url , notice: I18n.t('sessions.errors.already_logged_in') if @current_user
    session[:redirect_to] ||= request.referrer
  end

  def create
    @target = session[:redirect_to] 
    user = User.find_by_email(params[:email]).try(:authenticate, params[:password])

    if user
      session[:user_id] = user.id
      user.touch(:last_login)

      # Let's not leave old data in session.
      @target.nil? ? @target = root_url : session[:redirect_to] = nil

      redirect_to @target, notice: I18n.t('sessions.logged_in')
    else
      flash.now[:error] = I18n.t('sessions.errors.invalid_email_or_password')
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: I18n.t('sessions.logged_out')
  end

  def show
    # Users arrive here if they try to view a session.
    # This usually happens if they middle clicked a link with a destroy method.
    destroy
  end
end
