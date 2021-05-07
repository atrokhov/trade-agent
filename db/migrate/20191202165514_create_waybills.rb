class CreateWaybills < ActiveRecord::Migration[6.0]
  def change
    create_table :waybills do |t|
      t.boolean :status, default: false
      t.integer :number
      t.references :provider, null: false, foreign_key: true
      t.integer :manager_id
      t.integer :deliveryman_id
      t.integer :invoices, array: true, default: []
      t.float :tonnage
      t.datetime :begin_time
      t.datetime :end_time

      t.timestamps
    end
    add_foreign_key :waybills, :staffs, column: :manager_id
    add_index :waybills, :manager_id
    add_foreign_key :waybills, :staffs, column: :deliveryman_id
    add_index :waybills, :deliveryman_id
  end
end
