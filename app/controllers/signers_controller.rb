# frozen_string_literal: true

class SignersController < ApplicationController
  before_action :require_login
  before_action :set_contract
  before_action :set_signer, only: %i[destroy resend_email]

  def create
    @signer = @contract.contract_signers.build(signer_params)

    if @signer.save
      flash[:notice] = 'Signatário adicionado com sucesso!'
    else
      flash[:alert] = @signer.errors.full_messages.join(', ')
    end
    redirect_to edit_contract_path(@contract)
  end

  def destroy
    if @contract.status == 'draft'
      @signer.destroy
      flash[:notice] = 'Signatário removido.'
    else
      flash[:alert] = 'Não é possível remover signatários de um contrato já enviado.'
    end
    redirect_to edit_contract_path(@contract)
  end

  def resend_email
    if @signer.pending?
      ContractMailer.signature_request(@signer).deliver_now
      @contract.log_activity!('resent', user: current_user, signer: @signer, ip_address: client_ip)
      flash[:notice] = "Email reenviado para #{@signer.email}."
    else
      flash[:alert] = 'Este signatário já assinou ou recusou o contrato.'
    end
    redirect_to contract_path(@contract)
  end

  private

  def set_contract
    @contract = current_user.contracts.find(params[:contract_id])
  end

  def set_signer
    @signer = @contract.contract_signers.find(params[:id])
  end

  def signer_params
    params.require(:contract_signer).permit(:name, :email, :cpf, :role, :sign_order)
  end
end
