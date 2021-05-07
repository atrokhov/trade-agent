class CreateProductReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :product_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.json :liked_users
      t.json :disliked_users
      t.uuid :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
