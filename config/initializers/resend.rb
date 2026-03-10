# frozen_string_literal: true

Resend.api_key = ENV.fetch('RESEND_API_KEY', nil)

# Configurar Action Mailer para usar Resend via SMTP
if ENV['RESEND_API_KEY'].present?
  Rails.application.config.action_mailer.smtp_settings = {
    address: 'smtp.resend.com',
    port: 465,
    user_name: 'resend',
    password: ENV['RESEND_API_KEY'],
    authentication: :plain,
    enable_starttls_auto: true,
    ssl: true
  }
end
