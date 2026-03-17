# frozen_string_literal: true

class ContractMailer < ApplicationMailer
  def signature_request(signer)
    @signer = signer
    @contract = signer.contract
    @sign_url = signer.sign_url

    mail(
      to: signer.email,
      subject: "Contrato para assinatura: #{@contract.title}"
    )
  end

  def signature_confirmation(signer)
    @signer = signer
    @contract = signer.contract
    @signature = signer.contract_signature

    # Anexar PDF se o contrato já está totalmente assinado
    if @contract.status == 'signed'
      begin
        pdf_data = @contract.generate_signed_pdf
        attachments[pdf_filename(@contract, @signer.name)] = {
          mime_type: 'application/pdf',
          content: pdf_data
        }
      rescue StandardError => e
        Rails.logger.error "Erro ao gerar PDF para confirmação: #{e.message}"
      end
    end

    mail(
      to: signer.email,
      subject: "Contrato assinado com sucesso: #{@contract.title}"
    )
  end

  def signature_refused(signer)
    @signer = signer
    @contract = signer.contract
    @owner = @contract.user

    mail(
      to: @owner.email,
      subject: "Contrato recusado: #{@contract.title}"
    )
  end

  def contract_completed(contract)
    @contract = contract
    @signers = contract.contract_signers.signed
    @owner = contract.user

    # Nome do aluno (primeiro signatário manual)
    student = contract.contract_signers.where(auto_sign: false).first

    begin
      pdf_data = contract.generate_signed_pdf
      attachments[pdf_filename(contract, student&.name)] = {
        mime_type: 'application/pdf',
        content: pdf_data
      }
    rescue StandardError => e
      Rails.logger.error "Erro ao gerar PDF para conclusão: #{e.message}"
    end

    # Enviar para o dono do contrato + signatários auto_sign (empresa)
    company_emails = contract.contract_signers.where(auto_sign: true).pluck(:email)
    recipients = ([@owner.email] + company_emails).uniq

    mail(
      to: recipients,
      subject: "Todas as assinaturas concluidas: #{@contract.title}"
    )
  end

  private

  def pdf_filename(contract, signer_name = nil)
    parts = [contract.contract_number, contract.title.parameterize]
    parts << signer_name.parameterize if signer_name.present?
    "#{parts.join('-')}.pdf"
  end
end
