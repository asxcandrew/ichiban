class ReportsController < ApplicationController
  def index
    @prefix = "View Reports"
    @reports = Report.all
  end

  def create
    @report = Report.new(params[:report])
    @post = Post.find_by_id(params[:report][:post_id])
    @report.ip_address = request.ip
    response = { success: false }

    if @post
      if @report.save
        response.merge!(
          { success: true,
            message: "Report submitted!" })
      else
        response[:message] = @report.errors.first[1]
      end
    else
      response[:message] = "Post ##{params[:report][:post_id]} not found."
    end

    render json: response
  end

  def destroy
    @report = Report.find_by_id(params[:id])
    response = { success: false }

    if @report
      if @report.destroy
        response.merge!(
          { success: true,
            message: "Report ##{@report.id} deleted.",
            report_total:  @report.total })
      else
        response[:message] = @report.errors.full_messages.to_sentence
      end
    else
      response[:message] = "Report ##{params[:report][:id]} not found."
    end

    render json: response
  end
end
