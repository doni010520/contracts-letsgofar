# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_FROM', 'contratos@letsgofar.com.br')
  layout 'mailer'
end
