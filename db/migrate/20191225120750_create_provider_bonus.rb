class CreateProviderBonus < ActiveRecord::Migration[6.0]
  def change
    create_table :provider_bonus do |t|
      t.references :provider, null: false, foreign_key: true
      t.float :intent
      t.integer :bonus

      t.timestamps
    end
  end
end
