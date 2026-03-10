# frozen_string_literal: true

puts 'Criando usuário admin...'

User.find_or_create_by!(email: 'admin@letsgofar.com.br') do |user|
  user.name = 'Administrador'
  user.password = ENV.fetch('ADMIN_PASSWORD', 'admin123')
  user.role = 'admin'
end

puts 'Criando template padrão Let\'s Go Far...'

template_content = <<~HTML
  <div style="font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;">
    <h1 style="text-align: center; color: #1a365d; border-bottom: 2px solid #1a365d; padding-bottom: 10px;">
      CONTRATO DE PRESTAÇÃO DE SERVIÇOS<br>
      ASSESSORIA CONSULTIVA DE INGLÊS
    </h1>

    <p style="text-align: justify;">
      Pelo presente instrumento particular de contrato de prestação de serviços de Assessoria Consultiva de Inglês, 
      de um lado <strong>LETS GO FAR ENSINO DE IDIOMAS LTDA</strong>, pessoa jurídica de direito privado, 
      inscrita no CNPJ sob o nº 53.654.906/0001-96, com sede na Rua Ipacaetá, 159, sala 04, 
      Jardim Santa Francisca, Guarulhos/SP, CEP 07171-150, neste ato representada na forma de seu Contrato Social, 
      doravante denominada <strong>CONTRATADA</strong>;
    </p>

    <p style="text-align: justify;">
      E de outro lado <strong>{{contractor_name}}</strong>, inscrito(a) no CPF sob o nº {{contractor_cpf}}, 
      portador(a) do RG nº {{contractor_rg}}, residente e domiciliado(a) na {{contractor_address}}, 
      Bairro {{contractor_neighborhood}}, cidade de {{contractor_city}}/{{contractor_state}}, 
      CEP {{contractor_cep}}, e-mail {{contractor_email}}, telefone {{contractor_phone}}, 
      doravante denominado(a) <strong>CONTRATANTE</strong>;
    </p>

    <p style="text-align: justify;">
      As partes acima identificadas têm, entre si, justo e acertado o presente Contrato de Prestação de Serviços 
      de Assessoria Consultiva de Inglês, que se regerá pelas cláusulas seguintes e pelas condições descritas no presente.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA PRIMEIRA – DO OBJETO</h2>
    <p style="text-align: justify;">
      1.1. O presente contrato tem como objeto a prestação de serviços de Assessoria Consultiva de Inglês 
      pela CONTRATADA ao CONTRATANTE, conforme plano escolhido e descrito no Anexo I deste instrumento.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA SEGUNDA – DO PLANO CONTRATADO</h2>
    <p style="text-align: justify;">
      2.1. O CONTRATANTE optou pelo plano <strong>{{plan_name}}</strong>, com duração de {{plan_duration}}, 
      cujo detalhamento consta no Anexo I deste contrato.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA TERCEIRA – DO VALOR E FORMA DE PAGAMENTO</h2>
    <p style="text-align: justify;">
      3.1. O valor total dos serviços é de <strong>{{plan_value}}</strong>, a ser pago em {{installments_count}} parcela(s), 
      com vencimento todo dia {{installment_due_day}} de cada mês.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA QUARTA – DAS OBRIGAÇÕES DA CONTRATADA</h2>
    <p style="text-align: justify;">
      4.1. Prestar os serviços de assessoria consultiva de inglês conforme metodologia própria;<br>
      4.2. Disponibilizar os materiais necessários para o desenvolvimento das atividades;<br>
      4.3. Manter sigilo sobre as informações do CONTRATANTE.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA QUINTA – DAS OBRIGAÇÕES DO CONTRATANTE</h2>
    <p style="text-align: justify;">
      5.1. Efetuar os pagamentos nas datas acordadas;<br>
      5.2. Comparecer às sessões agendadas ou comunicar ausência com antecedência mínima de 24 horas;<br>
      5.3. Dedicar-se ao programa proposto.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA SEXTA – DO PRAZO</h2>
    <p style="text-align: justify;">
      6.1. O presente contrato terá vigência de {{plan_duration}}, contados a partir da data de assinatura.
    </p>

    <h2 style="color: #1a365d; margin-top: 30px;">CLÁUSULA SÉTIMA – DO FORO</h2>
    <p style="text-align: justify;">
      7.1. Fica eleito o foro da Comarca de Guarulhos/SP para dirimir quaisquer dúvidas oriundas do presente contrato.
    </p>

    <p style="text-align: justify; margin-top: 40px;">
      E por estarem assim justos e contratados, as partes assinam o presente instrumento eletronicamente, 
      declarando terem lido e concordado com todos os termos aqui estabelecidos.
    </p>

    <div style="margin-top: 60px; border-top: 1px solid #ccc; padding-top: 30px;">
      <h3 style="color: #1a365d;">ANEXO I – DETALHAMENTO DO PLANO</h3>
      <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr style="background-color: #f0f4f8;">
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold; width: 50%;">Plano</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{plan_name}}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Duração</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{plan_duration}}</td>
        </tr>
        <tr style="background-color: #f0f4f8;">
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Sessões Call Estratégica</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{sessions_call_estrategica}}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Sessões Individuais</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{sessions_individual}}</td>
        </tr>
        <tr style="background-color: #f0f4f8;">
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Sessões Consultivas em Grupo</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{sessions_group_consultive}}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Encontros em Grupo</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{sessions_group_meetings}}</td>
        </tr>
        <tr style="background-color: #f0f4f8;">
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Valor Total</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{plan_value}}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ccc; font-weight: bold;">Parcelas</td>
          <td style="padding: 10px; border: 1px solid #ccc;">{{installments_count}}x</td>
        </tr>
      </table>
    </div>
  </div>
HTML

ContractTemplate.find_or_create_by!(name: 'Contrato Padrão - Let\'s Go Far') do |template|
  template.user = User.first
  template.description = 'Contrato de Assessoria Consultiva de Inglês - Let\'s Go Far'
  template.content_html = template_content
  template.variable_fields = [
    { key: 'contractor_name', label: 'Nome do Contratante', type: 'text', required: true },
    { key: 'contractor_cpf', label: 'CPF', type: 'cpf', required: true },
    { key: 'contractor_rg', label: 'RG', type: 'text', required: false },
    { key: 'contractor_address', label: 'Endereço', type: 'text', required: true },
    { key: 'contractor_neighborhood', label: 'Bairro', type: 'text', required: true },
    { key: 'contractor_city', label: 'Cidade', type: 'text', required: true },
    { key: 'contractor_cep', label: 'CEP', type: 'cep', required: true },
    { key: 'contractor_state', label: 'Estado', type: 'select', required: true },
    { key: 'contractor_email', label: 'E-mail', type: 'email', required: true },
    { key: 'contractor_phone', label: 'Telefone', type: 'phone', required: true },
    { key: 'plan_name', label: 'Nome do Plano', type: 'text', required: true },
    { key: 'plan_duration', label: 'Duração do Plano', type: 'text', required: true },
    { key: 'sessions_call_estrategica', label: 'Sessões Call Estratégica', type: 'number', required: false },
    { key: 'sessions_individual', label: 'Sessões Individuais', type: 'number', required: false },
    { key: 'sessions_group_consultive', label: 'Sessões Consultivas em Grupo', type: 'number', required: false },
    { key: 'sessions_group_meetings', label: 'Encontros em Grupo', type: 'number', required: false },
    { key: 'plan_value', label: 'Valor Total', type: 'currency', required: true },
    { key: 'installments_count', label: 'Número de Parcelas', type: 'number', required: true },
    { key: 'installment_due_day', label: 'Dia de Vencimento', type: 'number', required: true }
  ]
end

puts 'Seeds concluídos!'
