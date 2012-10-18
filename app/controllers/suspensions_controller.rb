class SuspensionsController < ApplicationController
  def index
    @prefix = "View suspensions"
    @suspensions = Suspension.find(:all, order: "created_at DESC")
  end
  
  def create
    @suspension = Suspension.new(params[:suspension])
    response = { success: false }
    if @suspension.save
      response.merge!(
        { success: true,
          message: "Suspended #{@suspension.ip_address} until #{@suspension.ends_at}." })
    else
      response[:message] = @suspension.errors.first[1]
    end
    render json: response
  end

  def destroy
    @suspension = Suspension.find_by_id(params[:id])
    response = { success: false }

    if @suspension
      if @suspension.destroy
        response.merge!(
          { success: true,
            message: "Suspension for #{@suspension.ip_address} deleted.",
            total: Suspension.all.size })
      else
        response[:message] = @suspension.errors.full_messages.to_sentence
      end
    else
      response[:message] = "Report ##{params[:id]} not found."
    end

    render json: response
  end
end