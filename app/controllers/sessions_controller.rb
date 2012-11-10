class SessionsController < ApplicationController
  def new
    redirect_to root_url , notice: I18n.t('sessions.errors.already_logged_in') if @current_user
    session[:redirect_to] ||= request.referrer
  end

  def create
    user = User.find_by_email(params[:email])
    @target = session[:redirect_to] 

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.touch(:last_login)

      if @target.nil?
        @target = root_url
      else
        # Let's not leave old data in session.
        session[:redirect_to] = nil
      end

      redirect_to @target, notice: I18n.t('sessions.logged_in')
    else
      flash.now.alert = I18n.t('sessions.errors.invalid_email_or_password')
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: I18n.t('sessions.logged_out')
  end
end
