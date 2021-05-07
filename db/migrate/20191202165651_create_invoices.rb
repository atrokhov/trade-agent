class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :client, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.string :payment_type
      t.float :used_bonus
      t.boolean :status, default: false
      t.references :provider, null: false, foreign_key: true
      t.references :waybill, null: true, foreign_key: true
      t.integer :agent_id
      t.float :tonnage
      t.boolean :accept_by_client
      t.boolean :accept_by_provider
      t.datetime :canceled_by_client
      t.datetime :canceled_by_provider

      t.timestamps
    end
    add_foreign_key :invoices, :staffs, column: :agent_id
    add_index :invoices, :agent_id
  end
end
