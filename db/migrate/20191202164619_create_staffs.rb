class CreateStaffs < ActiveRecord::Migration[6.0]
  def change
    create_table :staffs do |t|
      t.string :role
      t.references :provider, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :district, null: true, foreign_key: true

      t.timestamps
    end
  end
end
