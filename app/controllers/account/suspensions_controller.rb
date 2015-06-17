class Account::SuspensionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_template
  # load_and_authorize_resource
  
  def index
    options = {}
    @prefix = I18n.t('suspensions.prefix')

    if params[:board_directory]
      @board = Board.find_by_directory!(params[:board_directory])

      # check_if_user_can!(:manage, Suspension, @board)
      @suspensions = @board.suspensions.order('created_at')
    else
      # @current_user.check_if_operator!
      @suspensions = current_user.suspensions.order('created_at DESC')
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
    response[:flash][:message] = I18n.t('suspensions.destroy.success', ip_address: @suspension.ip_address)
    @board = Board.find_by_directory!(params[:board_directory])
    redirect_to account_board_suspensions_path(@board)
  end

  private
    def set_template
      self.class.layout('layouts/board_management')
    end

    def ad_params
      params.require(:suspension).permit(:post_id, :reason, :ip_address, :board_id, :ends_at)
    end
end
