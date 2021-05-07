class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name
      t.json :address
      t.string :type

      t.timestamps
    end
  end
end
