class UsersController < ApplicationController
  before_filter :verify_permissions
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to(root_url, 
        notice: "Created User with email #{@user.email} and the #{@user.role} role.")
    else
      flash[:errors] = @user.errors.full_messages.to_sentence
      render "new"
    end
  end
end
