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
    @report = Report.find_by_id(params[:report][:id])
    response = {}

    if @report
      if @report.destroy
        response.merge!(
          { success: true,
            message: "Report ##{@report.id} deleted." })
      else
        response.merge!(
          { success: false,
            message: @report.errors.full_messages.to_sentence })
      end
    else
      response.merge!(
        { success: false,
          message: "Report ##{params[:report][:id]} not found."})
    end

    render json: response
  end
end
