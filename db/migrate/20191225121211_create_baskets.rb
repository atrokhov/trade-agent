class CreateBaskets < ActiveRecord::Migration[6.0]
  def change
    create_table :baskets do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :count
      t.integer :agent_id
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_foreign_key :baskets, :staffs, column: :agent_id
    add_index :baskets, :agent_id
  end
end
