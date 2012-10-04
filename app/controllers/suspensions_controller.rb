class SuspensionsController < ApplicationController
  def index
    @suspensions = Suspension.all
  end
  
  def create
    @suspension = Suspension.new(params[:suspension])
  end  
end