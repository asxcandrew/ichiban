class Account::SuspensionsController < ApplicationController
  # load_and_authorize_resource
  
  def index
    options = {}
    @prefix = I18n.t('suspensions.prefix')

    if params[:directory]
      @board = Board.find_by_directory!(params[:directory])

      # check_if_user_can!(:manage, Suspension, @board)
      @suspensions = @board.suspensions.order('created_at')
      options = { layout: 'board_management' }
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
    @suspension = Suspension.new(params[:suspension])
    # check_if_user_can!(:create, Suspension, @suspension.board)
    @suspension.save!
    response[:flash][:message] = I18n.t('suspensions.create.success', 
                                         ip_address: @suspension.ip_address, 
                                         ends_at: @suspension.ends_at)

    render json: response
  end

  def destroy
    @suspension = Suspension.find_by_id!(params[:id])
    response = { flash: { :type => :notice } }

    # check_if_user_can!(:destroy, Suspension, @suspension)
    @suspension.destroy
    response[:flash][:message] = I18n.t('suspensions.destroy.success', ip_address: @suspension.ip_address)

    render json: response
  end
end