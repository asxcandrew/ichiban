class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_operator

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_500
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
      @current_ability ||= AccountAbility.new(current_operator)
    end

    def current_operator
      if session[:operator_id]
        @current_operator ||= Operator.find_by_id(session[:operator_id])
      end
    end

    def verify_permissions
      unless @current_operator
        redirect_to(new_session_path, 
                    notice: "You must login to perform that action.")
      end
    end

    helper_method :current_operator
  # private_end
end
