# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = 'Você precisa fazer login para acessar esta página.'
      redirect_to login_path
    end
  end

  def client_ip
    request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first&.strip || request.remote_ip
  end
end
