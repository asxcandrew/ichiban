class SessionsController < ApplicationController
  def new
    redirect_to root_url , notice: "You're already logged in." if @current_operator
  end

  def create
    operator = Operator.find_by_email(params[:email])

    if operator && operator.authenticate(params[:password])
      session[:operator_id] = operator.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "Invalid email or password."
      render "new"
    end
  end

  def destroy
    session[:operator_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
