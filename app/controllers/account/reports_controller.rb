class Account::ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_template
  # load_and_authorize_resource

  def index
    options = {}
    @prefix = t('reports.index.prefix')
    if current_user.has_any_role? :operator, :administrator
      @reports = Report.all.order('created_at')
    else
      boards = Board.with_roles([:owner, :moderator], current_user).pluck(:id)
      @reports = Report.joins(:post, :board).where(boards:{id: boards}).order('created_at')
    end
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
    redirect_to account_reports_path
  end

  private
    def set_template
      self.class.layout('layouts/board_management')
    end
end
