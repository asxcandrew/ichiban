class OperatorsController < ApplicationController
  before_filter :verify_permissions
  def new
    @operator = Operator.new
  end

  def create
    @operator = Operator.new(params[:operator])
    
    if @operator.save
      redirect_to(root_url, 
        notice: "Created Operator with email #{@operator.email} and the #{@operator.role} role.")
    else
      flash[:errors] = @operator.errors.full_messages.to_sentence
      render "new"
    end
  end
end
