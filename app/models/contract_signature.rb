# frozen_string_literal: true

class ContractSignature < ApplicationRecord
  belongs_to :contract_signer

  delegate :contract, to: :contract_signer

  validates :signed_at, presence: true

  before_create :generate_signature_hash

  def generate_signature_hash
    data = "#{contract_signer_id}|#{signed_at.iso8601}|#{ip_address}|#{user_agent}"
    self.signature_hash = Digest::SHA256.hexdigest(data)
  end

  def valid_signature?
    expected = "#{contract_signer_id}|#{signed_at.iso8601}|#{ip_address}|#{user_agent}"
    signature_hash == Digest::SHA256.hexdigest(expected)
  end

  def location_info
    return nil unless geolocation.present?

    parts = []
    parts << geolocation['city'] if geolocation['city'].present?
    parts << geolocation['region'] if geolocation['region'].present?
    parts << geolocation['country'] if geolocation['country'].present?
    parts.join(', ')
  end

  def evidence_summary
    {
      signer_name: contract_signer.name,
      signer_email: contract_signer.email,
      confirmation_name: confirmation_name,
      confirmation_cpf: confirmation_cpf,
      ip: ip_address,
      location: location_info,
      device: parse_user_agent,
      timestamp: signed_at.iso8601,
      hash: signature_hash
    }
  end

  private

  def parse_user_agent
    return 'Desconhecido' unless user_agent.present?

    case user_agent
    when /Windows/
      'Windows'
    when /Mac OS X/
      'macOS'
    when /Linux/
      'Linux'
    when /Android/
      'Android'
    when /iPhone|iPad/
      'iOS'
    else
      'Outro'
    end
  end
end
