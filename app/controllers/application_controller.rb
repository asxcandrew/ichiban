
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user

  unless Rails.application.config.consider_all_requests_local
    # rescue_from Exception, :with => :render_500
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
    rescue_from ActionController::UnknownAction, :with => :render_404
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  end

  private
    def render_404(exception)
      @not_found_path = exception.message
      respond_to do |format|
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

    # TODO: This method gets called twice sometimes. Not sure why.
    def verify_permissions
      unless @current_user
        session[:redirect_to] = request.env["REQUEST_PATH"]
        flash.now[:error] = I18n.t('sessions.require_log_in')
        redirect_to(new_session_path)
      end
    end

    helper_method :current_user
  # private_end
end
