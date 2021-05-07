class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :social_media
      t.string :address
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
