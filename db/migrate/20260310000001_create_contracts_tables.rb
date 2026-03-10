# frozen_string_literal: true

class CreateContractsTables < ActiveRecord::Migration[7.1]
  def change
    # Usuários (autenticação simples)
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, default: 'user'
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :users, :email, unique: true

    # Templates de contrato
    create_table :contract_templates do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :content_html, null: false
      t.boolean :active, default: true
      t.jsonb :variable_fields, default: []
      t.timestamps
    end

    # Contratos
    create_table :contracts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contract_template, foreign_key: true
      t.string :contract_number, null: false
      t.string :title, null: false
      t.text :content_html, null: false
      t.jsonb :variables, default: {}
      t.string :status, default: 'draft', null: false
      t.string :document_hash
      t.datetime :sent_at
      t.datetime :signed_at
      t.datetime :expires_at
      t.timestamps
    end
    add_index :contracts, :contract_number, unique: true
    add_index :contracts, :status

    # Signatários
    create_table :contract_signers do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :cpf
      t.string :role, default: 'contractor'
      t.string :sign_token, null: false
      t.string :status, default: 'pending'
      t.integer :sign_order, default: 1
      t.datetime :viewed_at
      t.datetime :signed_at
      t.datetime :refused_at
      t.text :refusal_reason
      t.timestamps
    end
    add_index :contract_signers, :sign_token, unique: true
    add_index :contract_signers, [:contract_id, :email], unique: true

    # Assinaturas (evidências)
    create_table :contract_signatures do |t|
      t.references :contract_signer, null: false, foreign_key: true
      t.string :ip_address
      t.text :user_agent
      t.jsonb :geolocation, default: {}
      t.datetime :signed_at, null: false
      t.string :signature_hash
      t.string :browser_fingerprint
      t.string :confirmation_name
      t.string :confirmation_cpf
      t.timestamps
    end

    # Atividades (log)
    create_table :contract_activities do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :contract_signer, foreign_key: true
      t.string :activity_type, null: false
      t.jsonb :metadata, default: {}
      t.string :ip_address
      t.timestamps
    end
    add_index :contract_activities, :activity_type
  end
end
