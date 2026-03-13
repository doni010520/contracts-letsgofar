# frozen_string_literal: true

class ContractsController < ApplicationController
  before_action :require_login
  before_action :set_contract, only: %i[show edit update destroy send_for_signature cancel duplicate preview download_pdf edit_content update_content]

  def index
    @contracts = current_user.contracts.includes(:contract_signers).order(created_at: :desc)
    
    if params[:status].present?
      @contracts = @contracts.where(status: params[:status])
    end
  end

  def show
    @activities = @contract.contract_activities.recent.limit(20)
  end

  def new
    @contract = current_user.contracts.build
    @templates = ContractTemplate.active
  end

  def create
    @contract = current_user.contracts.build(contract_params)

    if params[:template_id].present?
      template = ContractTemplate.find(params[:template_id])
      @contract.contract_template = template
      @contract.content_html = template.content_html
      @contract.title ||= template.name
    end

    if @contract.save
      @contract.log_activity!('created', user: current_user, ip_address: client_ip)
      flash[:notice] = 'Contrato criado com sucesso!'
      redirect_to edit_contract_path(@contract)
    else
      @templates = ContractTemplate.active
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @templates = ContractTemplate.active
  end

  def update
    # Se mudou o template
    if params[:template_id].present? && params[:template_id] != @contract.contract_template_id.to_s
      template = ContractTemplate.find(params[:template_id])
      @contract.contract_template = template
      @contract.content_html = template.apply_variables(@contract.variables || {})
    end

    # Aplicar variáveis ao conteúdo se fornecidas
    if params[:contract][:variables].present?
      variables = params[:contract][:variables].to_unsafe_h
      @contract.variables = variables
      
      if @contract.contract_template.present?
        @contract.content_html = @contract.contract_template.apply_variables(variables)
      end
    end

    if @contract.update(contract_params.except(:variables))
      @contract.log_activity!('updated', user: current_user, ip_address: client_ip)
      flash[:notice] = 'Contrato atualizado com sucesso!'
      redirect_to contract_path(@contract)
    else
      @templates = ContractTemplate.active
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @contract.status == 'draft'
      @contract.destroy
      flash[:notice] = 'Contrato excluído.'
    else
      flash[:alert] = 'Não é possível excluir um contrato já enviado.'
    end
    redirect_to contracts_path
  end

  def send_for_signature
    if @contract.send_for_signature!
      flash[:notice] = 'Contrato enviado para assinatura!'
    else
      flash[:alert] = 'Não foi possível enviar o contrato. Verifique se há signatários cadastrados.'
    end
    redirect_to contract_path(@contract)
  end

  def cancel
    reason = params[:reason]
    
    if @contract.cancel!(reason)
      flash[:notice] = 'Contrato cancelado.'
    else
      flash[:alert] = 'Não foi possível cancelar o contrato.'
    end
    redirect_to contract_path(@contract)
  end

  def duplicate
    new_contract = @contract.duplicate!(current_user)
    flash[:notice] = 'Contrato duplicado com sucesso!'
    redirect_to edit_contract_path(new_contract)
  end

  def preview
    render layout: false
  end

  def download_pdf
    # Por enquanto, renderiza HTML para impressão
    render :preview, layout: 'pdf'
  end

  def edit_content
    unless @contract.status == 'draft'
      flash[:alert] = 'Não é possível editar um contrato já enviado.'
      redirect_to contract_path(@contract)
    end
  end

  def update_content
    if @contract.status != 'draft'
      flash[:alert] = 'Não é possível editar um contrato já enviado.'
      redirect_to contract_path(@contract)
      return
    end

    if @contract.update(content_html: params[:contract][:content_html])
      @contract.log_activity!('content_edited', user: current_user, ip_address: client_ip)
      flash[:notice] = 'Conteúdo do contrato atualizado com sucesso!'
      redirect_to contract_path(@contract)
    else
      render :edit_content, status: :unprocessable_entity
    end
  end

  private

  def set_contract
    @contract = current_user.contracts.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(:title, :content_html, :expires_at, :plan_start_date, :plan_end_date)
  end
end
