class Product < ApplicationRecord
  belongs_to :subcategory
  belongs_to :provider
  has_many :order
  has_many :product_review

  has_one_attached :image

  def save_price_with_discount
    self.retail_price_with_discount = self.retail_price - (self.retail_price / 100 * self.retail_discount)
    self.wholesale_price_with_discount = self.wholesale_price - (self.wholesale_price / 100 * self.wholesale_discount)
  end
end
