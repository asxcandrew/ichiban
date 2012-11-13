class SuspensionsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @prefix = I18n.t('suspensions.prefix')

    if params[:directory]
      @board = Board.find_by_directory(params[:directory])

      if check_if_user?(can?(:manage, Board), @board)
        @suspensions = @board.suspensions.order('created_at')
      else
        raise CanCan::AccessDenied
      end

    elsif @current_user.operator?
      @suspensions = @current_user.suspensions.order('created_at DESC')
    else
      raise CanCan::AccessDenied
    end

    respond_to do |format|
      format.html
      format.json { render json: @suspensions }
    end
  end
  
  def create
    @suspension = Suspension.new(params[:suspension])
    response = { success: false }
    if check_if_user?(can?(:create, Suspension), @suspension.board)
      if @suspension.save
        response.merge!(
          { success: true,
            message: I18n.t('suspensions.create.success', 
                            ip_address: @suspension.ip_address, 
                            ends_at: @suspension.ends_at) })
      else
        response[:message] = @suspension.errors.first[1]
      end
    else
      response[:message] = I18n.t('suspensions.create.not_authorized')
    end

    render json: response
  end

  def destroy
    @suspension = Suspension.find_by_id(params[:id])
    response = { success: false }

    if @suspension
      if check_if_user?(can?(:destroy, Suspension), @suspension)
        if @suspension.destroy
          response.merge!(
            { success: true,
              message: I18n.t('suspensions.destroy.success', ip_address: @suspension.ip_address),
              total: Suspension.all.size })
        else
          response[:message] = @suspension.errors.full_messages.to_sentence
        end
      else
        response[:message] = I18n.t('suspensions.destroy.not_authorized', ip_address: @suspension.ip_address)
      end
    else
      response[:message] = I18n.t('suspensions.errors.suspension_not_found', suspension_id: params[:id])
    end

    render json: response
  end
end