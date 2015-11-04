class Account::SuspensionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_template
  # load_and_authorize_resource
  
  def index
    options = {}
    @prefix = t('suspensions.index.prefix')
    if current_user.has_any_role? :operator, :administrator
      @suspensions = Suspension.all.order('created_at')
    else
      boards = Board.with_roles([:owner, :moderator], current_user).pluck(:id)
      @suspensions = Suspension.where(board_id: boards).order('created_at')
    end

    respond_to do |format|
      format.html { render options }
      format.json { render json: @suspensions }
    end
  end
  
  def create
    response = { flash: { :type => :notice } }
    @suspension = Suspension.new(ad_params)
    @suspension.save!
    response[:flash][:message] = I18n.t('suspensions.create.success', 
                                         ip_address: @suspension.ip_address, 
                                         ends_at: @suspension.ends_at)

    render json: response
  end

  def destroy
    @suspension = Suspension.find_by_id!(params[:id])
    response = { flash: { :type => :notice } }

    authorize! :destroy, @suspension
    @suspension.destroy
    response[:flash][:message] = t('suspensions.destroy.success', ip_address: @suspension.ip_address)
    redirect_to account_suspensions_path
  end

  private
    def set_template
      self.class.layout('layouts/board_management')
    end

    def ad_params
      params.require(:suspension).permit(:post_id, :reason, :ip_address, :board_id, :ends_at)
    end
end
