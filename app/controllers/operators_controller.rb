class OperatorsController < ApplicationController
  before_filter :verify_permissions
  def new
    @roles = Role.all
    @operator = Operator.new
  end

  def create
    @roles = Role.all
    @operator = Operator.new(params[:operator])
    
    if @operator.save
      redirect_to(root_url, 
        notice: "Created Operator with email #{@operator.email} and the #{@operator.role.name} role.")
    else
      flash[:errors] = @operator.errors.full_messages.to_sentence
      render "new"
    end
  end
end
