class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def create
    @report = Report.new(params[:report])
    @report.ip_address = request.ip
    response = {}

    if @report.save
      response.merge!(
        { success: true,
          message: "Report submitted!" })
    else
      response.merge!(
        { success: false,
          message: @report.errors.full_messages.to_sentence })
    end

    render json: response
  end

  def destroy
  end
end
