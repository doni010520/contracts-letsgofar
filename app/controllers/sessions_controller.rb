# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to contracts_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Bem-vindo, #{user.name}!"
      redirect_to contracts_path
    else
      flash.now[:alert] = 'Email ou senha inválidos.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Você saiu do sistema.'
    redirect_to login_path
  end
end
