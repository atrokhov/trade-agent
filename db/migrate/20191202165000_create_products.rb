class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.uuid :uuid
      t.string :name
      t.text :description
      t.references :subcategory, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.json :characteristics
      t.float :retail_price
      t.float :wholesale_price
      t.float :retail_price_with_discount
      t.float :wholesale_price_with_discount
      t.decimal :rate, default: 0
      t.boolean :bestseller, default: false
      t.boolean :novelty, default: false
      t.string :status, default: :active
      t.json :buy_with
      t.float :retail_discount, default: 0
      t.float :wholesale_discount, default: 0
      t.integer :pack, default: 0
      t.float :weight, default: 0
      t.integer :clients_favorites, array: true, default: []

      t.timestamps
    end
  end
end
