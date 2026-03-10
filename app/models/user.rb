# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :contracts, dependent: :destroy
  has_many :contract_templates, dependent: :destroy
  has_many :contract_activities, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  before_save :downcase_email

  scope :active, -> { where(active: true) }
  scope :admins, -> { where(role: 'admin') }

  def admin?
    role == 'admin'
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
