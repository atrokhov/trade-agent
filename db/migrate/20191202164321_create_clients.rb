class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :city
      t.string :phone, array: true, default: []
      t.datetime :date_of_birth
      t.string :client_type

      t.timestamps
    end
  end
end
