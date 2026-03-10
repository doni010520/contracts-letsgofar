# Contratos Let's Go Far

Sistema de geração e assinatura eletrônica de contratos para Let's Go Far Ensino de Idiomas.

## Funcionalidades

- ✅ Criação de templates de contrato com variáveis dinâmicas
- ✅ Geração de contratos a partir de templates
- ✅ Envio de contratos por email (via Resend)
- ✅ Assinatura eletrônica com coleta de evidências (IP, user agent, timestamp)
- ✅ Histórico de atividades do contrato
- ✅ Múltiplos signatários por contrato
- ✅ Recusa de contrato com motivo
- ✅ Duplicação de contratos e templates

## Requisitos

- Ruby 3.2.2
- PostgreSQL 15+
- Redis (para jobs em background)
- Conta no Resend (para envio de emails)

## Instalação

### Com Docker (Recomendado)

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/contracts-letsgofar.git
cd contracts-letsgofar
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
```

3. Inicie os containers:
```bash
docker-compose up -d
```

4. Acesse: http://localhost:3000

### Sem Docker

1. Instale as dependências:
```bash
bundle install
```

2. Configure o banco de dados:
```bash
rails db:create db:migrate db:seed
```

3. Inicie o servidor:
```bash
rails server
```

4. Em outro terminal, inicie o Sidekiq:
```bash
bundle exec sidekiq
```

## Configuração do Resend

1. Crie uma conta em https://resend.com
2. Gere uma API Key
3. Adicione ao seu `.env`:
```
RESEND_API_KEY=re_xxxxxxxxxxxx
MAIL_FROM=contratos@seudominio.com.br
```

4. Configure o domínio no Resend para evitar emails em spam

## Primeiro Acesso

Após rodar o seed, acesse com:
- **Email:** admin@letsgofar.com.br
- **Senha:** (definida em ADMIN_PASSWORD no .env, padrão: admin123)

## Estrutura do Projeto

```
app/
├── controllers/
│   ├── contracts_controller.rb     # CRUD de contratos
│   ├── contract_templates_controller.rb  # CRUD de templates
│   ├── signers_controller.rb       # Gerenciar signatários
│   └── signatures_controller.rb    # Assinatura pública
├── models/
│   ├── contract.rb                 # Contrato
│   ├── contract_template.rb        # Template
│   ├── contract_signer.rb          # Signatário
│   ├── contract_signature.rb       # Evidência de assinatura
│   └── contract_activity.rb        # Log de atividades
├── mailers/
│   └── contract_mailer.rb          # Emails de contrato
└── views/
    ├── contracts/                  # Views de contratos
    ├── signatures/                 # Views de assinatura pública
    └── contract_mailer/            # Templates de email
```

## Fluxo de Assinatura

1. Criar contrato a partir de template
2. Preencher variáveis do contrato
3. Adicionar signatários (nome, email, CPF opcional)
4. Enviar para assinatura
5. Signatário recebe email com link único
6. Signatário visualiza e assina (ou recusa)
7. Sistema coleta evidências (IP, user agent, timestamp)
8. Confirmação enviada por email

## Validade Jurídica

Este sistema utiliza assinatura eletrônica simples, válida conforme:
- **MP 2.200-2/2001** - Institui a ICP-Brasil
- **Lei 14.063/2020** - Dispõe sobre assinaturas eletrônicas

A assinatura eletrônica simples é adequada para contratos de prestação de serviços.

## Licença

Proprietário - Let's Go Far Ensino de Idiomas LTDA
