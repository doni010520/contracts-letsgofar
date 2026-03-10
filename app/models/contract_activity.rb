# frozen_string_literal: true

class ContractActivity < ApplicationRecord
  belongs_to :contract
  belongs_to :user, optional: true
  belongs_to :contract_signer, optional: true

  validates :activity_type, presence: true

  scope :recent, -> { order(created_at: :desc) }

  ACTIVITY_TYPES = %w[
    created updated sent viewed signed refused
    cancelled expired completed resent
  ].freeze

  def activity_label
    {
      'created' => 'Contrato criado',
      'updated' => 'Contrato atualizado',
      'sent' => 'Enviado para assinatura',
      'viewed' => 'Visualizado',
      'signed' => 'Assinado',
      'refused' => 'Recusado',
      'cancelled' => 'Cancelado',
      'expired' => 'Expirado',
      'completed' => 'Todas as assinaturas concluídas',
      'resent' => 'Email reenviado'
    }[activity_type] || activity_type
  end

  def activity_icon
    {
      'created' => '📝',
      'updated' => '✏️',
      'sent' => '📤',
      'viewed' => '👁️',
      'signed' => '✅',
      'refused' => '❌',
      'cancelled' => '🚫',
      'expired' => '⏰',
      'completed' => '🎉',
      'resent' => '📧'
    }[activity_type] || '📋'
  end

  def actor_name
    if user.present?
      user.name
    elsif contract_signer.present?
      contract_signer.name
    else
      'Sistema'
    end
  end
end
