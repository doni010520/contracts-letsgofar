class AddAutoSignToContractSigners < ActiveRecord::Migration[7.1]
  def change
    add_column :contract_signers, :auto_sign, :boolean, default: false, null: false
  end
end
