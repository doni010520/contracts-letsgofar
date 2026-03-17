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
  before_save :extract_plan_dates_from_variables
  after_create :add_company_signer

  COMPANY_SIGNER = {
    name: 'Ianka Cavalcante',
    email: 'letsgofaridioma@gmail.com',
    role: 'company'
  }.freeze

  scope :draft, -> { where(status: 'draft') }
  scope :pending, -> { where(status: 'pending') }
  scope :partially_signed, -> { where(status: 'partially_signed') }
  scope :signed, -> { where(status: 'signed') }
  scope :refused, -> { where(status: 'refused') }
  scope :expired, -> { where(status: 'expired') }
  scope :cancelled, -> { where(status: 'cancelled') }
  
  # Scopes para controle de renovação
  scope :expiring_this_month, -> { where(plan_end_date: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :expiring_next_month, -> { where(plan_end_date: Date.current.next_month.beginning_of_month..Date.current.next_month.end_of_month) }
  scope :expiring_in_days, ->(days) { where(plan_end_date: Date.current..(Date.current + days.days)) }
  scope :expired_plans, -> { where('plan_end_date < ?', Date.current) }
  scope :active_plans, -> { where('plan_end_date >= ?', Date.current) }

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
    status == 'draft' && contract_signers.where(auto_sign: false).any?
  end

  def can_cancel?
    %w[draft pending partially_signed].include?(status)
  end

  def send_for_signature!
    return false unless can_send?

    update!(status: 'pending', sent_at: Time.current, expires_at: 30.days.from_now)

    contract_signers.pending.each do |signer|
      if signer.auto_sign?
        signer.sign!({
          ip_address: '127.0.0.1',
          user_agent: 'AutoSign/1.0 (Let\'s Go Far)',
          geolocation: {},
          browser_fingerprint: 'auto_sign',
          confirmation_name: signer.name,
          confirmation_cpf: signer.cpf
        })
      else
        ContractMailer.signature_request(signer).deliver_now
      end
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
      begin
        ContractMailer.contract_completed(self).deliver_now
      rescue StandardError => e
        Rails.logger.error "Erro ao enviar email de conclusão com PDF: #{e.message}"
      end
    elsif signers.any?(&:signed?)
      update!(status: 'partially_signed')
    end
  end

  def generate_signed_pdf
    html = ApplicationController.render(
      template: 'contracts/preview',
      layout: 'pdf',
      assigns: { contract: self }
    )

    WickedPdf.new.pdf_from_string(html, encoding: 'UTF-8')
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
    
    contract_signers.where(auto_sign: false).each do |signer|
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

  def add_company_signer
    contract_signers.create!(
      name: COMPANY_SIGNER[:name],
      email: COMPANY_SIGNER[:email],
      role: COMPANY_SIGNER[:role],
      auto_sign: true,
      sign_order: 0
    )
  rescue StandardError => e
    Rails.logger.error "Erro ao adicionar signatária da empresa: #{e.message}"
  end

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

  def extract_plan_dates_from_variables
    return unless variables.present?

    # Extrair data de início
    if variables['plan_start_date'].present?
      self.plan_start_date = parse_flexible_date(variables['plan_start_date'])
    end

    # Calcular data de término automaticamente baseado no início + duração
    if plan_start_date.present? && variables['plan_duration'].present?
      calculated_end = calculate_end_date(plan_start_date, variables['plan_duration'])
      if calculated_end.present?
        self.plan_end_date = calculated_end
        formatted_date = calculated_end.strftime('%d/%m/%Y')

        # Atualiza a variável para aparecer no contrato
        self.variables = variables.merge('plan_end_date' => formatted_date)

        # Substitui no HTML se ainda não foi substituído
        if content_html.present? && content_html.include?('{{plan_end_date}}')
          self.content_html = content_html.gsub('{{plan_end_date}}', formatted_date)
        end
      end
    elsif variables['plan_end_date'].present?
      # Fallback: usar data de término informada manualmente
      self.plan_end_date = parse_flexible_date(variables['plan_end_date'])
    end
  end

  def parse_flexible_date(date_string)
    return nil if date_string.blank?

    if date_string.match?(%r{\A\d{2}/\d{2}/\d{4}\z})
      # Formato brasileiro DD/MM/YYYY
      Date.strptime(date_string, '%d/%m/%Y')
    elsif date_string.match?(%r{\A\d{4}-\d{2}-\d{2}\z})
      # Formato ISO YYYY-MM-DD
      Date.parse(date_string)
    else
      Date.parse(date_string)
    end
  rescue Date::Error, ArgumentError
    nil
  end

  def calculate_end_date(start_date, duration_text)
    # Extrai número e unidade da duração (ex: "6 meses", "12 meses", "1 ano")
    duration_text = duration_text.to_s.downcase.strip
    
    if duration_text =~ /(\d+)\s*(mes|mês|meses)/i
      months = $1.to_i
      start_date + months.months
    elsif duration_text =~ /(\d+)\s*(ano|anos)/i
      years = $1.to_i
      start_date + years.years
    elsif duration_text =~ /(\d+)\s*(semana|semanas)/i
      weeks = $1.to_i
      start_date + weeks.weeks
    else
      # Tenta extrair apenas o número e assume meses
      if duration_text =~ /(\d+)/
        start_date + $1.to_i.months
      else
        nil
      end
    end
  end
end
