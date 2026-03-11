# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.first
  end

  def logged_in?
    true
  end

  def require_login
    # Autenticação desabilitada
  end

  def client_ip
    request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first&.strip || request.remote_ip
  end
end
