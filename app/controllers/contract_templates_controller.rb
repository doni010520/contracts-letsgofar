# frozen_string_literal: true

class ContractTemplatesController < ApplicationController
  before_action :require_login
  before_action :set_template, only: %i[show edit update destroy preview duplicate]

  def index
    @templates = ContractTemplate.order(created_at: :desc)
  end

  def show; end

  def new
    @template = ContractTemplate.new
  end

  def create
    @template = ContractTemplate.new(template_params)
    @template.user = current_user

    if @template.save
      flash[:notice] = 'Template criado com sucesso!'
      redirect_to contract_templates_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @template.update(template_params)
      flash[:notice] = 'Template atualizado com sucesso!'
      redirect_to contract_templates_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @template.contracts.any?
      flash[:alert] = 'Não é possível excluir um template que possui contratos vinculados.'
    else
      @template.destroy
      flash[:notice] = 'Template excluído.'
    end
    redirect_to contract_templates_path
  end

  def preview
    render layout: false
  end

  def duplicate
    new_template = @template.duplicate!(current_user)
    flash[:notice] = 'Template duplicado com sucesso!'
    redirect_to edit_contract_template_path(new_template)
  end

  private

  def set_template
    @template = ContractTemplate.find(params[:id])
  end

  def template_params
    params.require(:contract_template).permit(:name, :description, :content_html, :active, variable_fields: [])
  end
end
