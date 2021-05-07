class CreateClientBonus < ActiveRecord::Migration[6.0]
  def change
    create_table :client_bonus do |t|
      t.integer :current
      t.integer :added_bonus
      t.references :client, null: false, foreign_key: true
      t.integer :bonus

      t.timestamps
    end
  end
end
