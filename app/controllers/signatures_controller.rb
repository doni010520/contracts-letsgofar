# frozen_string_literal: true

class SignaturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :refuse]
  
  before_action :set_signer
  before_action :check_signer_status, except: [:success, :refused]

  def show
    @contract = @signer.contract
    @signer.mark_as_viewed!(client_ip)
  end

  def create
    if params[:confirmation_name].blank?
      flash.now[:alert] = 'Por favor, digite seu nome completo para confirmar.'
      @contract = @signer.contract
      return render :show, status: :unprocessable_entity
    end

    signature_params = {
      ip_address: client_ip,
      user_agent: request.user_agent,
      geolocation: fetch_geolocation,
      browser_fingerprint: params[:fingerprint],
      confirmation_name: params[:confirmation_name],
      confirmation_cpf: params[:confirmation_cpf]
    }

    if @signer.sign!(signature_params)
      redirect_to sign_success_path(@signer.sign_token)
    else
      flash.now[:alert] = 'Ocorreu um erro ao processar sua assinatura. Tente novamente.'
      @contract = @signer.contract
      render :show, status: :unprocessable_entity
    end
  end

  def success
    @contract = @signer.contract
  end

  def refuse
    reason = params[:reason].presence || 'Não informado'
    
    if @signer.refuse!(reason, client_ip)
      redirect_to sign_refused_path(@signer.sign_token)
    else
      flash.now[:alert] = 'Ocorreu um erro ao processar sua recusa.'
      @contract = @signer.contract
      render :show, status: :unprocessable_entity
    end
  end

  def refused
    @contract = @signer.contract
  end

  private

  def set_signer
    @signer = ContractSigner.find_by!(sign_token: params[:token])
  rescue ActiveRecord::RecordNotFound
    render plain: 'Link inválido ou expirado.', status: :not_found
  end

  def check_signer_status
    return if @signer.pending?

    if @signer.signed?
      redirect_to sign_success_path(@signer.sign_token)
    elsif @signer.refused?
      redirect_to sign_refused_path(@signer.sign_token)
    end
  end

  def fetch_geolocation
    # Em produção, você pode usar um serviço como ipinfo.io
    # Por ora, retornamos vazio
    {}
  end
end
