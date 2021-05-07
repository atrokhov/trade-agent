class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :product, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.string :payment_type
      t.float :used_bonus
      t.text :wishes
      t.datetime :arrival_at
      t.string :status
      t.float :total
      t.integer :count
      t.references :shop, null: false, foreign_key: true
      t.references :invoice, null: true, foreign_key: true
      t.integer :agent_id
      t.float :tonnage
      t.boolean :accept_by_client
      t.boolean :accept_by_provider
      t.datetime :canceled_by_client
      t.datetime :canceled_by_provider

      t.timestamps
    end
    add_foreign_key :orders, :staffs, column: :agent_id
    add_index :orders, :agent_id
  end
end
