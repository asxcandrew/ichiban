class ReportsController < ApplicationController

  def create
    response = { flash: { :type => :notice } }
    params[:report][:ip_address] = request.ip
    
    @report = Report.create(ad_params)
    response[:flash][:message] = I18n.t('reports.create.success')

    render json: response
  end

  private
    def ad_params
      params.require(:report).permit(:post_id, :comment, :ip_address)
    end
end
