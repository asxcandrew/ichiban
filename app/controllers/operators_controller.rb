class OperatorsController < ApplicationController
  def new
    @operator = Operator.new
  end

  def create
    @operator = Operator.new(params[:operator])
    
    if @operator.save
      redirect_to root_url, notice: "Signed up!"
    else
      flash[:errors] = @operator.errors.full_messages.to_sentence
      render "new"
    end
  end
end
