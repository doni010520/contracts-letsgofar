# frozen_string_literal: true

# Template completo do contrato Let's Go Far
# Execute no rails console: load 'db/seeds_template.rb'

template_content = <<~HTML
<div style="font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6;">
  
  <!-- Logo -->
  <div style="text-align: center; margin-bottom: 30px;">
    <img src="https://letsgofaridiomas.com/wp-content/uploads/2024/01/logo-lets-go-far.png" alt="Let's Go Far" style="max-width: 150px;" onerror="this.style.display='none'">
  </div>

  <h1 style="text-align: center; color: #333333; font-size: 24px; margin-bottom: 30px;">
    CONTRATO DE PRESTAÇÃO DE SERVIÇOS
  </h1>

  <p style="text-align: justify;">
    Para fins deste contrato, os termos abaixo terão os seguintes significados:
  </p>

  <!-- CONTRATANTE -->
  <h3 style="color: #333333; margin-top: 25px;">CONTRATANTE ("ALUNO" | "MENTORADO")</h3>
  <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
    <tr><td style="padding: 8px; border: 1px solid #ddd; width: 200px;"><strong>Nome do aluno:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_name}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>CPF/MF do aluno:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_cpf}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>RG do aluno:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_rg}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Endereço:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_address}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Bairro:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_neighborhood}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Município:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_city}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>CEP:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_cep}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Estado:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_state}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>E-mail:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_email}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Telefone:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_phone}}</td></tr>
    <tr><td style="padding: 8px; border: 1px solid #ddd;"><strong>Data de nascimento:</strong></td><td style="padding: 8px; border: 1px solid #ddd;">{{contractor_birthdate}}</td></tr>
  </table>

  <!-- CONTRATADA -->
  <h3 style="color: #333333; margin-top: 25px;">CONTRATADA ("ESCOLA" | "MENTORA")</h3>
  <p style="text-align: justify;">
    <strong>LETS GO FAR ENSINO DE IDIOMAS LTDA</strong> (LET'S GO FAR), inscrita no CNPJ nº 53.654.906/0001-96, 
    com sede na Rua Ipacaetá, 159, sala 04, Guarulhos/SP, CEP 07171-150 no Estado São Paulo, 
    telefone (11) 99777-3116, e-mail contato@letsgofaridiomas.com.
  </p>

  <h3 style="color: #333333; margin-top: 25px;">SERVIÇO</h3>
  <p><strong>Assessoria consultiva de inglês</strong></p>

  <p style="text-align: justify; margin-top: 20px;">
    O presente contrato representa a totalidade do acordo entre as partes, substituindo quaisquer 
    entendimentos, negociações ou acordos anteriores que possam conflitar com as disposições aqui estabelecidas.
  </p>

  <p style="text-align: justify;">
    As Partes têm, entre si, celebrado o presente <strong>CONTRATO DE PRESTAÇÃO DE SERVIÇOS</strong>, de 
    acordo com as seguintes cláusulas e condições:
  </p>

  <!-- CLÁUSULA 1 - OBJETO -->
  <h2 style="color: #333333; margin-top: 30px; border-bottom: 2px solid #333333; padding-bottom: 5px;">1. OBJETO DO CONTRATO</h2>
  
  <p style="text-align: justify;">
    <strong>1.1.</strong> O objeto deste contrato consiste na prestação de serviços de assessoria consultiva de inglês, 
    conforme ANEXO I deste instrumento.
  </p>
  
  <p style="text-align: justify;">
    <strong>Parágrafo primeiro:</strong> O serviço contratado será realizado na plataforma Google Meet, que deverá 
    ser acessado pelo link enviado pela secretaria no prazo de 7 (sete) dias da data da contratação.
  </p>
  
  <p style="text-align: justify;">
    <strong>Parágrafo segundo:</strong> O CONTRATANTE terá acesso ao calendário de aulas no ato da contratação 
    que contemplará dia das aulas, feriados e recesso.
  </p>
  
  <p style="text-align: justify;">
    <strong>Parágrafo terceiro:</strong> A CONTRATADA poderá alterar o calendário de aulas, mediante aviso prévio, 
    cuja comunicação será realizada por WhatsApp cadastrado neste contrato.
  </p>
  
  <p style="text-align: justify;">
    <strong>Parágrafo quarto:</strong> A CONTRATADA poderá, a qualquer tempo e a seu exclusivo critério, sem 
    qualquer ônus, remanejar ou fundir as turmas já formadas e/ou em andamento, desde que 
    pertencentes ao nível (CEFR – classificação de Cambridge).
  </p>
  
  <p style="text-align: justify;">
    <strong>Parágrafo quinto:</strong> O serviço de assessoria consultiva de inglês contempla o plantão consultivo, 
    que deverá ser utilizado pelo MENTORADO nos termos do ANEXO I.
  </p>

  <!-- CLÁUSULA 2 - OBRIGAÇÕES DA CONTRATADA -->
  <h2 style="color: #333333; margin-top: 30px; border-bottom: 2px solid #333333; padding-bottom: 5px;">2. OBRIGAÇÕES DA CONTRATADA</h2>
  
  <p style="text-align: justify;">
    <strong>2.1</strong> A CONTRATADA compromete-se a buscar, de forma contínua, melhorias nos processos e serviços 
    prestados, propondo soluções e inovações que possam beneficiar o CONTRATANTE.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.2</strong> A CONTRATADA deve proporcionar um ensino que atenda aos padrões educacionais vigentes, 
    assegurando que os professores sejam qualificados e que o conteúdo programático seja adequado 
    ao nível e às expectativas dos alunos.
  </p>
  
  <p style="text-align: justify; margin-left: 20px;">
    <strong>Parágrafo único:</strong> O CONTRATANTE não possuirá professores fixos, podendo ser alterados pela 
    CONTRATADA a qualquer tempo e a seu exclusivo critério.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.3</strong> É responsabilidade da CONTRATADA disponibilizar e/ou indicar os materiais necessários para o 
    acompanhamento das aulas, como livros, apostilas e recursos complementares (plataforma LET'S GO FAR PLUS).
  </p>
  
  <p style="text-align: justify;">
    <strong>2.4</strong> A CONTRATADA deve respeitar a carga horária estabelecida no contrato garantindo que as aulas 
    sejam ministradas conforme o cronograma acordado.
  </p>
  
  <p style="text-align: justify; margin-left: 20px;">
    <strong>Parágrafo único:</strong> Em caso de falta/ausência no dia da aula o CONTRATANTE poderá solicitar a 
    gravação da aula.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.5</strong> A CONTRATADA deve fornecer informações claras sobre o curso disponibilizadas no ANEXO I 
    deste instrumento, incluindo objetivos, conteúdo programático, quantidade de aulas, duração 
    aproximada, assegurando que o aluno esteja plenamente ciente dos serviços contratados.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.6</strong> Ao término do pacote de aulas, a CONTRATADA é responsável por emitir certificados ou 
    declarações que comprovem a conclusão e o aproveitamento do aluno, conforme previsto no contrato.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.7</strong> A CONTRATADA compromete-se a oferecer os conteúdos, aulas e orientações pedagógicas 
    necessárias para o aprendizado da língua inglesa. Contudo, o progresso e desempenho do 
    CONTRATANTE dependem de seu engajamento e dedicação, não sendo a CONTRATADA 
    responsável por resultados específicos, considerando que a eficácia do curso está diretamente 
    vinculada ao esforço individual do CONTRATANTE, sua assiduidade e cumprimento das atividades recomendadas.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.8</strong> A assessoria consultiva de inglês oferecida pela CONTRATADA destina-se a traçar estratégias e 
    um plano de ação específicos para atender às necessidades identificadas do Mentorado, com o 
    objetivo de otimizar o aprendizado e atingir os resultados acordados no momento da contratação. 
    Esse serviço inclui acompanhamento técnico e orientações individualizadas para o 
    desenvolvimento das habilidades em inglês, além da implementação de estratégias ajustadas ao objetivo pactuado.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.9</strong> A responsabilidade da CONTRATADA limita-se à elaboração e orientação do plano de ação e à 
    supervisão técnica contínua do aprendizado de inglês e das estratégias recomendadas. A 
    CONTRATADA compromete-se a fornecer todas as ferramentas e o suporte necessários para o 
    sucesso do Mentorado, mas não garante resultados específicos, uma vez que o desempenho e 
    progresso dependem, em grande parte, do comprometimento do Mentorado em seguir o plano de forma integral.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.10</strong> A CONTRATADA não se responsabiliza por resultados específicos, como níveis específicos de 
    fluência ou tempo determinado para atingir o objetivo, pois o sucesso do plano individualizado 
    depende do engajamento, assiduidade e dedicação do Mentorado. Em caso de desempenho aquém 
    do esperado, não caberá à CONTRATADA qualquer tipo de ressarcimento, indenização ou 
    responsabilidade adicional, considerando que a efetividade do serviço está condicionada à adesão 
    do Mentorado às atividades e estratégias definidas.
  </p>
  
  <p style="text-align: justify;">
    <strong>2.11</strong> A CONTRATADA exime-se de qualquer responsabilidade por eventual não alcance dos 
    objetivos desejados pelo Mentorado que decorra da falta de comprometimento, cumprimento 
    parcial das atividades recomendadas, ou qualquer desvio do planejamento estabelecido. Sendo 
    assim, não caberá ao Mentorado o direito a ressarcimento, indenização ou compensação 
    financeira, uma vez que a CONTRATADA cumpriu integralmente sua obrigação de fornecer os serviços propostos.
  </p>
