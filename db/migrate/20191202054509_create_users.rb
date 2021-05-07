class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :phone
      t.string :role
      t.boolean :blocked, default: false

      t.timestamps
    end
  end
end
