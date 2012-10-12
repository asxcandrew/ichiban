class SuspensionsController < ApplicationController
  def index
    @suspensions = Suspension.all
  end
  
  def create
    @suspension = Suspension.new(params[:suspension])
    ends_at = Chronic.parse("2 days from now").to_date
    @suspension.ends_at = ends_at
    response = { success: false }
    if @suspension.save
      response.merge!(
        { success: true,
          message: "Suspended #{@suspension.post.ip_address} until #{@suspension.ends_at}." })
    else
      response[:message] = @suspension.errors.first[1]
    end
    render json: response
  end
end