class Account::ReportsController < ApplicationController
  before_filter :set_template
  # load_and_authorize_resource

  def index
    options = {}
    @prefix = I18n.t('reports.index.prefix')

    @board = Board.find_by_directory!(params[:board_directory])

    # check_if_user_can!(:manage, Report, @board)
    @reports = @board.reports.order('created_at')
    respond_to do |format|
      format.html { render options }
      format.json { render json: @reports }
    end
  end

  def destroy
    response = { flash: { :type => :notice } }
    @report = Report.find_by_id!(params[:id])
    
    authorize! :destroy, @report
    @report.destroy
    response[:flash][:message] = I18n.t('reports.destroy.success', report_id: @report.id)
    @board = Board.find_by_directory!(params[:board_directory])
    redirect_to account_board_reports_path(@board)
  end

  private
    def set_template
      self.class.layout('layouts/board_management')
    end
end
