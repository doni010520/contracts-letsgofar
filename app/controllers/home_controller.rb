# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if logged_in?
      redirect_to contracts_path
    else
      redirect_to login_path
    end
  end

  def health
    render json: { status: 'ok', timestamp: Time.current.iso8601 }
  end
end
