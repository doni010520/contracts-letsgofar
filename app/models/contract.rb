# frozen_string_literal: true

class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :contract_template, optional: true
  has_many :contract_signers, dependent: :destroy
  has_many :contract_activities, dependent: :destroy

  validates :title, presence: true
  validates :content_html, presence: true
  validates :contract_number, presence: true, uniqueness: true

  before_validation :generate_contract_number, on: :create
  before_save :generate_document_hash, if: :content_html_changed?

  scope :draft, -> { where(status: 'draft') }
  scope :pending, -> { where(status: 'pending') }
  scope :partially_signed, -> { where(status: 'partially_signed') }
  scope :signed, -> { where(status: 'signed') }
  scope :refused, -> { where(status: 'refused') }
  scope :expired, -> { where(status: 'expired') }
  scope :cancelled, -> { where(status: 'cancelled') }

  # Status possíveis
  STATUSES = %w[draft pending partially_signed signed refused expired cancelled].freeze

  def status_label
    {
      'draft' => 'Rascunho',
      'pending' => 'Aguardando Assinatura',
      'partially_signed' => 'Parcialmente Assinado',
      'signed' => 'Assinado',
      'refused' => 'Recusado',
      'expired' => 'Expirado',
      'cancelled' => 'Cancelado'
    }[status] || status
  end

  def status_color
    {
      'draft' => 'gray',
      'pending' => 'yellow',
      'partially_signed' => 'blue',
      'signed' => 'green',
      'refused' => 'red',
      'expired' => 'orange',
      'cancelled' => 'gray'
    }[status] || 'gray'
  end

  def can_send?
    status == 'draft' && contract_signers.any?
  end

  def can_cancel?
    %w[draft pending partially_signed].include?(status)
  end

  def send_for_signature!
    return false unless can_send?

    update!(status: 'pending', sent_at: Time.current, expires_at: 30.days.from_now)
    
    contract_signers.pending.each do |signer|
      ContractMailer.signature_request(signer).deliver_later
    end
    
    log_activity!('sent', metadata: { signers_count: contract_signers.count })
    true
  end

  def cancel!(reason = nil)
    return false unless can_cancel?

    update!(status: 'cancelled')
    log_activity!('cancelled', metadata: { reason: reason })
    true
  end

  def update_signature_status!
    return if status.in?(%w[signed refused cancelled expired])

    signers = contract_signers.reload
    
    if signers.any?(&:refused?)
      update!(status: 'refused')
    elsif signers.all?(&:signed?)
      update!(status: 'signed', signed_at: Time.current)
      log_activity!('completed')
    elsif signers.any?(&:signed?)
      update!(status: 'partially_signed')
    end
  end

  def check_expiration!
    return unless status == 'pending' && expires_at.present? && expires_at < Time.current
    
    update!(status: 'expired')
    log_activity!('expired')
  end

  def duplicate!(user = nil)
    new_contract = dup
    new_contract.user = user || self.user
    new_contract.status = 'draft'
    new_contract.contract_number = nil
    new_contract.sent_at = nil
    new_contract.signed_at = nil
    new_contract.expires_at = nil
    new_contract.save!
    
    contract_signers.each do |signer|
      new_contract.contract_signers.create!(
        name: signer.name,
        email: signer.email,
        cpf: signer.cpf,
        role: signer.role,
        sign_order: signer.sign_order
      )
    end
    
    new_contract
  end

  def log_activity!(activity_type, user: nil, signer: nil, metadata: {}, ip_address: nil)
    contract_activities.create!(
      activity_type: activity_type,
      user: user,
      contract_signer: signer,
      metadata: metadata,
      ip_address: ip_address
    )
  end

  def contractor_name
    variables&.dig('contractor_name') || contract_signers.first&.name
  end

  private

  def generate_contract_number
    return if contract_number.present?

    year = Time.current.year
    last_number = Contract.where('contract_number LIKE ?', "CTR-#{year}-%")
                          .order(contract_number: :desc)
                          .first&.contract_number
    
    if last_number
      sequence = last_number.split('-').last.to_i + 1
    else
      sequence = 1
    end
    
    self.contract_number = "CTR-#{year}-#{sequence.to_s.rjust(5, '0')}"
  end

  def generate_document_hash
    self.document_hash = Digest::SHA256.hexdigest("#{contract_number}|#{content_html}|#{Time.current.to_i}")
  end
end
