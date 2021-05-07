class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.json :address
      t.string :phone
      t.text :description
      t.string :status, default: :active
      t.string :min_amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
