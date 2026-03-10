# frozen_string_literal: true

class ContractTemplate < ApplicationRecord
  belongs_to :user, optional: true
  has_many :contracts, dependent: :nullify

  validates :name, presence: true
  validates :content_html, presence: true

  scope :active, -> { where(active: true) }

  def apply_variables(variables = {})
    result = content_html.dup
    variables.each do |key, value|
      placeholder = "{{#{key}}}"
      result.gsub!(placeholder, value.to_s)
    end
    result
  end

  def extract_placeholders
    content_html.scan(/\{\{(\w+)\}\}/).flatten.uniq
  end

  def duplicate!(user = nil)
    new_template = dup
    new_template.name = "#{name} (Cópia)"
    new_template.user = user if user
    new_template.save!
    new_template
  end
end
