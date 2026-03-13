# frozen_string_literal: true

class ContractSigner < ApplicationRecord
  belongs_to :contract
  has_one :contract_signature, dependent: :destroy
  has_many :contract_activities, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :contract_id, message: 'já adicionado neste contrato' }

  before_create :generate_sign_token

  scope :pending, -> { where(status: 'pending') }
  scope :signed, -> { where(status: 'signed') }
  scope :refused, -> { where(status: 'refused') }
  scope :by_order, -> { order(:sign_order) }

  def pending?
    status == 'pending'
  end

  def signed?
    status == 'signed'
  end

  def refused?
    status == 'refused'
  end

  def sign!(signature_params)
    return false unless pending?

    transaction do
      create_contract_signature!(
        ip_address: signature_params[:ip_address],
        user_agent: signature_params[:user_agent],
        geolocation: signature_params[:geolocation] || {},
        signed_at: Time.current,
        browser_fingerprint: signature_params[:browser_fingerprint],
        confirmation_name: signature_params[:confirmation_name],
        confirmation_cpf: signature_params[:confirmation_cpf]
      )

      update!(status: 'signed', signed_at: Time.current)
      
      contract.log_activity!(
        'signed',
        signer: self,
        ip_address: signature_params[:ip_address],
        metadata: { signer_name: name, signer_email: email }
      )
      
      contract.update_signature_status!
      
      # Enviar confirmação
      ContractMailer.signature_confirmation(self).deliver_now
    end

    true
  rescue StandardError => e
    Rails.logger.error "Erro ao assinar contrato: #{e.message}"
    false
  end

  def refuse!(reason, ip_address = nil)
    return false unless pending?

    update!(
      status: 'refused',
      refused_at: Time.current,
      refusal_reason: reason
    )

    contract.log_activity!(
      'refused',
      signer: self,
      ip_address: ip_address,
      metadata: { signer_name: name, reason: reason }
    )

    contract.update_signature_status!
    
    # Notificar criador do contrato
    ContractMailer.signature_refused(self).deliver_now

    true
  end

  def mark_as_viewed!(ip_address = nil)
    return if viewed_at.present?

    update!(viewed_at: Time.current)
    
    contract.log_activity!(
      'viewed',
      signer: self,
      ip_address: ip_address,
      metadata: { signer_name: name }
    )
  end

  def sign_url
    Rails.application.routes.url_helpers.public_sign_url(
      sign_token,
      host: ENV.fetch('APP_HOST', 'localhost:3000'),
      protocol: ENV.fetch('APP_PROTOCOL', 'http')
    )
  end

  def regenerate_token!
    generate_sign_token
    save!
  end

  def status_label
    {
      'pending' => 'Pendente',
      'signed' => 'Assinado',
      'refused' => 'Recusado'
    }[status] || status
  end

  private

  def generate_sign_token
    self.sign_token = SecureRandom.urlsafe_base64(32)
  end
end
