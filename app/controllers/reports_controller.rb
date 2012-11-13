class ReportsController < ApplicationController
  load_and_authorize_resource

  def index
    @prefix = I18n.t('reports.index.prefix')

    if params[:directory]
      @board = Board.find_by_directory(params[:directory])

      if check_if_user?(can?(:manage, Board), @board)
        @reports = @board.reports.order('created_at')
      else
        raise CanCan::AccessDenied
      end

    elsif @current_user.operator?
      @reports = @current_user.reports.order('created_at')
    else
      raise CanCan::AccessDenied
    end

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
            message: I18n.t('reports.create.success') })
      else
        response[:message] = @report.errors.first[1]
      end
    else
      response[:message] = I18n.t('reports.create.post_not_found', post_id: params[:report][:post_id])
    end

    render json: response
  end

  def destroy
    @report = Report.find_by_id(params[:id])
    response = { success: false }

    if @report
      if check_if_user?(can?(:destroy, Report), @report)
        if @report.destroy
          response.merge!(
            { success: true,
              message: I18n.t('reports.destroy.success', report_id: @report.id),
              report_total:  Report.all.size })
        else
          response[:message] = @report.errors.full_messages.to_sentence
        end
      else
        response[:message] = I18n.t('reports.destroy.not_authorized', report_id: params[:id])
      end
    else
      response[:message] = I18n.t('reports.destroy.report_not_found', report_id: params[:id])
    end

    render json: response
  end
end
