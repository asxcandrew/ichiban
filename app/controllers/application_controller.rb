class ApplicationController < ActionController::Base
  include IchibanAuthorization
  protect_from_forgery
  before_filter :current_user

  rescue_from RestClient::ServerBrokeConnection do |exception|
    flash[:error] = "The server broke the connection. Did the request timeout?"
    redirect_to request.referrer
  end

  rescue_from Cloudinary::CarrierWave::UploadError do |exception|
    flash[:error] = exception.message
    redirect_to request.referrer
  end

  unless Rails.application.config.consider_all_requests_local
    # rescue_from Exception, :with => :render_500
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
    rescue_from ActionController::UnknownAction, :with => :render_404
  end
  rescue_from CanCan::AccessDenied, :with => :render_403
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  private
    def render_403(exception)
      @verboten = exception.message

      respond_to do |format|
        format.json do
          render json: { flash: { :type => :error, message: @verboten }, responseText: @verboten }, status: 403
        end 
        format.html do
          if @current_user
            flash[:error] = @verboten
            redirect_to root_url
          else # Must not be logged in...
            # Let's hold on to that path so we can get the user back to where they were going.
            session[:redirect_to] = request.env["REQUEST_PATH"]
            
            flash[:error] = I18n.t('sessions.require_log_in')
            redirect_to(new_session_path)
          end
        end
      end
    end

    def render_404(exception)
      @not_found_path = exception.message
      respond_to do |format|
        format.json do
          render json: { flash: { :type => :error, message: @not_found_path }, responseText: @not_found_path }, status: 404 
        end
        format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
        format.all { render nothing: true, status: 404 }
      end
    end

    def render_500(exception)
      @error = exception
      respond_to do |format|
        format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
        format.all { render nothing: true, status: 500}
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_user
      if session[:user_id]
        @current_user ||= User.find_by_id(session[:user_id])
      end
    end

    helper_method :current_user
  # private_end
end
