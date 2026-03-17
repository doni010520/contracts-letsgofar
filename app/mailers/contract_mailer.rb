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
      pdf_data = @contract.generate_signed_pdf
      attachments["#{@contract.contract_number}.pdf"] = {
        mime_type: 'application/pdf',
        content: pdf_data
      }
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

    pdf_data = contract.generate_signed_pdf
    attachments["#{contract.contract_number}-assinado.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf_data
    }

    mail(
      to: @owner.email,
      subject: "Todas as assinaturas concluidas: #{@contract.title}"
    )
  end
end
