class ReportsController < ApplicationController
  before_filter :verify_permissions, except: [:create]
  def index
    @prefix = "View Reports"
    @reports = Report.find(:all, order: "created_at")

    respond_to do |format|
      format.html
      format.json { render json: @reports }
    end
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
      if can?(:manage, Report)
        if @report.destroy
          response.merge!(
            { success: true,
              message: "Report ##{@report.id} deleted.",
              report_total:  Report.all.size })
        else
          response[:message] = @report.errors.full_messages.to_sentence
        end
      else
        response[:message] = "You are not permitted to delete report ##{params[:id]}."
      end
    else
      response[:message] = "Report ##{params[:id]} not found."
    end

    render json: response
  end
end
