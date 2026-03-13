# frozen_string_literal: true

class AddPlanDatesToContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :plan_start_date, :date
    add_column :contracts, :plan_end_date, :date
    
    # Índice para consultas rápidas de contratos expirando
    add_index :contracts, :plan_end_date
    add_index :contracts, [:status, :plan_end_date]
  end
end
