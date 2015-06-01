class Account::ReportsController < ApplicationController
  # load_and_authorize_resource

  def index
    options = {}
    @prefix = I18n.t('reports.index.prefix')

    if params[:directory]
      @board = Board.find_by_directory!(params[:directory])

      # check_if_user_can!(:manage, Report, @board)
      @reports = @board.reports.order('created_at')
      options = { layout: 'board_management' }
    else
      # @current_user.check_if_operator!
      @reports = current_user.reports.order('created_at')
    end

    respond_to do |format|
      format.html { render options }
      format.json { render json: @reports }
    end
  end

  def create
    response = { flash: { :type => :notice } }
    params[:report][:ip_address] = request.ip

    Post.find_by_id!(params[:report][:post_id])
    @report = Report.create!(params[:report])
    response[:flash][:message] = I18n.t('reports.create.success')

    render json: response
  end

  def destroy
    response = { flash: { :type => :notice } }
    @report = Report.find_by_id!(params[:id])
    
    check_if_user_can!(:destroy, Report, @report)
    @report.destroy
    response[:flash][:message] = I18n.t('reports.destroy.success', report_id: @report.id)

    render json: response
  end
end
