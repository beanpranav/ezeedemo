class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ensure_security_headers :hsts => {:max_age => 631138519, :include_subdomain => true},
                          :x_frame_options  => {:value => 'SAMEORIGIN'},
                          :x_content_type_options => {:value => "nosniff"},
                          :x_xss_protection => {:value => 1, :mode => 'block'},
                          :csp => false

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # helper_method :current_subdomain

  protected

  # for allowing :name as a strong parameter while signup and account update.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :phone_number, :role, :status)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :phone_number, :role, :status, :current_password)
    end
  end

  # def current_subdomain
  #   @current_subdomain = request.subdomains.first
  # end

end