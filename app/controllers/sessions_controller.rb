class SessionsController < ApplicationController
  def new
    redirect_to root_url , notice: "You're already logged in." if @current_user
  end

  def create
    user = User.find_by_email(params[:email])
    @target = session[:redirect_to] 

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if @target.nil?
        @target == root_url
      else
        # Let's not leave old data in session.
        session[:redirect_to] = nil
      end

      redirect_to @target, notice: "Logged in!"
    else
      flash.now.alert = "Invalid email or password."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
